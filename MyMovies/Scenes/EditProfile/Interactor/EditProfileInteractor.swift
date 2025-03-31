//
//  EditProfileInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/10/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class EditProfileInteractor: EditProfileInteractorProtocol {
    weak var presenter: EditProfileInteractorOutputProtocol?

    private let networkManager: NetworkManagerProtocol
    private let firestoreDB = Firestore.firestore()

    private var currentUser: UserProfileProtocol?

    // MARK: - Init
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    // MARK: - EditProfileInteractorProtocol
    func fetchUserProfile() {
        guard let user = Auth.auth().currentUser,
              let email = user.email else {
            return
        }

        // Fetch full data and update UI if user is signed in
        fetchAdditionalUserData(uid: user.uid, email: email)
    }

    func updateUserProfile(name: String, email: String, image: UIImage?) {
    }
}

// MARK: - Private
extension EditProfileInteractor {
    private func fetchAdditionalUserData(uid: String, email: String) {
        firestoreDB.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: error)
                }

                return
            }

            guard let userData = snapshot?.data() else {
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: AppError.customError(message: "Failed to fetch user data", comment: "Error message for failed user data fetch"))
                }

                return
            }

            // Return if data wasn't stored -> Wait until it'll be stored and fetching be triggered by the listener
            guard let name = userData["name"] as? String else {
                return
            }

            currentUser = UserProfile(
                id: uid,
                name: name,
                email: email,
                profileImageURL: userData["profileImageURL"] as? URL
            )

            DispatchQueue.main.async {
                self.presenter?.didFetchUserProfile(self.currentUser!)
            }
        }
    }
}
