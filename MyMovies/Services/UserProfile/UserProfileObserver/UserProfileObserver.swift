//
//  UserProfileObserver.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 01/04/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol UserProfileObserverProtocol: AnyObject {
    var delegate: UserProfileObserverDelegate? { get set }

    func startObserving()
    func fetchUserProfile()
    func stopObserving()
}

protocol UserProfileObserverDelegate: AnyObject {
    func didFetchUserProfile(_ user: UserProfileProtocol)
    func didFailToFetchData(with error: Error)
    func didBeginProfileUpdate()
    func didLogOut()
}

final class UserProfileObserver: UserProfileObserverProtocol {
    weak var delegate: UserProfileObserverDelegate?

    private var authListenerHandle: AuthStateDidChangeListenerHandle?
    private var firestoreListener: ListenerRegistration?
    private let firestoreDB: Firestore

    init(firestoreDB: Firestore = Firestore.firestore()) {
        self.firestoreDB = firestoreDB
    }

    // MARK: - Public
    // Start observing FirebaseAuth and Firestore changes
    func startObserving() {
        authListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }

            if let user = user, let email = user.email {
                // We have a signed-in user; set up Firestore listener if needed.
                self.setupFirestoreListener(uid: user.uid, email: email)
            } else {
                // User logged out or does not exist
                self.removeFirestoreListener()
                DispatchQueue.main.async {
                    self.delegate?.didLogOut()
                }
            }
        }
    }

    func fetchUserProfile() {
        guard let user = Auth.auth().currentUser,
              let email = user.email else { return }

        getUserData(uid: user.uid, email: email)
    }

    // Stop observing
    func stopObserving() {
        if let authHandle = authListenerHandle {
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
        removeFirestoreListener()
    }
}

// MARK: - Private
extension UserProfileObserver {
    private func setupFirestoreListener(uid: String, email: String) {
        // If we already have a listener, do not attach another.
        guard firestoreListener == nil else { return }

        firestoreListener = firestoreDB.collection("users").document(uid).addSnapshotListener { [weak self] _, error in
                guard let self = self else { return }

                if let error = error {
                    DispatchQueue.main.async {
                        self.delegate?.didFailToFetchData(with: error)
                    }
                }
                // Fetch the latest user data
                self.getUserData(uid: uid, email: email)
        }
    }

    private func getUserData(uid: String, email: String) {
        DispatchQueue.main.async {
            self.delegate?.didBeginProfileUpdate()
        }

        firestoreDB.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.didFailToFetchData(with: error)
                }

                return
            }

            guard let data = snapshot?.data(),
                  let name = data["name"] as? String else {
                DispatchQueue.main.async {
                    let error = AppError.customError(
                        message: "Failed to fetch user data",
                        comment: "Missing user fields"
                    )

                    self.delegate?.didFailToFetchData(with: error)
                }

                return
            }

            let userProfile = UserProfile(
                id: uid,
                name: name,
                email: email,
                profileImageURL: URL(string: data["profileImageURL"] as? String ?? "")
            )

            DispatchQueue.main.async {
                self.delegate?.didFetchUserProfile(userProfile)
            }
        }
    }

    private func removeFirestoreListener() {
        firestoreListener?.remove()
        firestoreListener = nil
    }
}
