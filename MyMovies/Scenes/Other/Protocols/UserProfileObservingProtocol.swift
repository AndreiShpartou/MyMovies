//
//  UserProfileObservingProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 01/04/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// MARK: - Protocols for User Profile Observing
protocol UserProfileObservingProtocol: AnyObject {
    var firestoreDB: Firestore { get }
    var authObserver: AuthStateDidChangeListenerHandle { get }
    var presenter: UserProfileObservingOutputProtocol? { get set }
    var firestoreObserver: ListenerRegistration? { get set }
}

protocol UserProfileObservingOutputProtocol: AnyObject {
    func didFetchUserProfile(_ user: UserProfileProtocol)
    func didFailToFetchData(with error: Error)
    func didLogOut()
}

// MARK: - Default Implemantation
extension UserProfileObservingProtocol {
    // Fetches additional user data from Firestore and notifies the presenter.
    func fetchAdditionalUserData(uid: String, email: String) {
        firestoreDB.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: error)
                }
                return
            }

            guard let data = snapshot?.data(),
                  let name = data["name"] as? String else {
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: AppError.customError(message: "User data missing", comment: ""))
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
                self.presenter?.didFetchUserProfile(userProfile)
            }
        }
    }

    // MARK: - Observers
    func setupAuthObserver(auth: Auth = Auth.auth()) -> AuthStateDidChangeListenerHandle {
        return auth.addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            if let user = user, let email = user.email {
                // Attach Firestore listener if not already attached.
                _ = self.setupFireStoreListener(uid: user.uid, email: email)
            } else {
                // User is signed out or does not exist
                self.firestoreObserver?.remove()
                firestoreObserver = nil

                DispatchQueue.main.async {
                    self.presenter?.didLogOut()
                }
            }
        }
    }

    func setupFireStoreListener(uid: String, email: String) -> ListenerRegistration? {
        guard firestoreObserver == nil else { return nil }

        return firestoreDB.collection("users").document(uid).addSnapshotListener { [weak self] _, error in
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: error)
                }
            }
            // Fetch the latest data.
            self.fetchAdditionalUserData(uid: uid, email: email)
        }
    }

    
}
