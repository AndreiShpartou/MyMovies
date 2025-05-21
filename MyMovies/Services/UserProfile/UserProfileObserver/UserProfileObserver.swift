//
//  UserProfileObserver.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 01/04/2025.
//
import Foundation

protocol UserProfileObserverProtocol: AnyObject {
    var delegate: UserProfileObserverDelegate? { get set }

    func startObserving()
    func fetchUserProfile()
    func stopObserving()
}

protocol UserProfileObserverDelegate: AnyObject {
    func didFetchUserProfile(_ user: UserProfile)
    func didFailToFetchData(with error: Error)
    func didBeginProfileUpdate()
    func didLogOut()
}

final class UserProfileObserver: UserProfileObserverProtocol {
    weak var delegate: UserProfileObserverDelegate?

    private let authService: AuthServiceProtocol
    private let profileDocumentsStoreService: ProfileDocumentsStoreServiceProtocol
    private var authListenerHandle: NSObjectProtocol?
    private var profileDocumentsListener: NSObjectProtocol?

    init(
        authService: AuthServiceProtocol,
        profileDocumentsStoreService: ProfileDocumentsStoreServiceProtocol
    ) {
        self.authService = authService
        self.profileDocumentsStoreService = profileDocumentsStoreService
    }

    // MARK: - Public
    // Start observing FirebaseAuth and Firestore changes
    func startObserving() {
        authListenerHandle = authService.addAuthStateDidChangeListener { [weak self] userProfile in
            guard let self = self else { return }

            if let userProfile = userProfile {
                // We have a signed-in user; set up profileDocumentsListener if needed.
                self.setupProfileDocumentsListener(uid: userProfile.id, email: userProfile.email)
            } else {
                // User logged out or does not exist
                self.removeProfileDocumentsListener()
                DispatchQueue.main.async {
                    self.delegate?.didLogOut()
                }
            }
        }
    }

    func fetchUserProfile() {
        guard let userProfile = authService.currentUser else { return }

        getUserDocumentsData(uid: userProfile.id, email: userProfile.email)
    }

    // Stop observing
    func stopObserving() {
        if let authHandle = authListenerHandle {
            authService.removeAuthStateDidChangeListener(authHandle)
        }
        removeProfileDocumentsListener()
    }
}

// MARK: - Private
extension UserProfileObserver {
    private func setupProfileDocumentsListener(uid: String, email: String) {
        // If we already have a listener, do not attach another one.
        guard profileDocumentsListener == nil else { return }

        profileDocumentsListener = profileDocumentsStoreService.addSnapshotListener(collection: "users", document: uid) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                // Fetch the latest user data
                self.getUserDocumentsData(uid: uid, email: email)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.didFailToFetchData(with: error)
                }
            }
        }
    }

    private func getUserDocumentsData(uid: String, email: String) {
        DispatchQueue.main.async {
            // Update presenter to show loading indicator
            self.delegate?.didBeginProfileUpdate()
        }

        // Get the latest user profile document
        profileDocumentsStoreService.getDocument(collection: "users", document: uid) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let userData):
                let name = userData["name"] as? String
                // User profile document exists and contains required fields
                let userProfile = UserProfile(
                    id: uid,
                    email: email,
                    name: name,
                    profileImageURL: URL(string: userData["profileImageURL"] as? String ?? "")
                )

                DispatchQueue.main.async {
                    self.delegate?.didFetchUserProfile(userProfile)
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.didFailToFetchData(with: error)
                }
            }
        }
    }

    private func removeProfileDocumentsListener() {
        profileDocumentsStoreService.removeSnapshotListener(profileDocumentsListener)
        profileDocumentsListener = nil
    }
}
