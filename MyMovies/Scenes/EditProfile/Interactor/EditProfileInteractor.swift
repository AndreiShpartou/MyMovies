//
//  EditProfileInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/10/2024.
//

import Foundation

final class EditProfileInteractor: EditProfileInteractorProtocol {
    weak var presenter: EditProfileInteractorOutputProtocol?

    private let profileDataStoreService: ProfileDataStoreServiceProtocol
    private let authService: AuthServiceProtocol
    private let profileDocumentsStoreService: ProfileDocumentsStoreServiceProtocol

    // Store the fetched user profile
    private var currentUser: UserProfileProtocol?

    // MARK: - Init
    init(
        profileDataStoreService: ProfileDataStoreServiceProtocol = CloudinaryService(),
        authService: AuthServiceProtocol = FirebaseAuthService(),
        profileDocumentsStoreService: ProfileDocumentsStoreServiceProtocol = FirebaseFirestoreService()
    ) {
        self.profileDataStoreService = profileDataStoreService
        self.authService = authService
        self.profileDocumentsStoreService = profileDocumentsStoreService
    }

    // MARK: - EditProfileInteractorProtocol
    func fetchUserProfile() {
        // Check if user is signed in
        guard let userProfile = authService.currentUser else {
            DispatchQueue.main.async {
                self.presenter?.didFailToFetchData(with: AppError.customError(message: "User is not signed in", comment: ""))
            }

            return
        }

        // Fetch full data and update UI if user is signed in
        fetchUserDocumentsData(uid: userProfile.id, email: userProfile.email)
    }

    // Update the user's profile in the Firestore (and upload a new image if provided)
    func updateUserProfile(name: String, profileImage: Data?) {
        completeGroupUpdate(name: name, image: profileImage)
    }
}

// MARK: - Private FetchData
extension EditProfileInteractor {
    // Fetch user documents data from the profileDocumentsStoreService (FirebaseFirestore by default)
    private func fetchUserDocumentsData(uid: String, email: String) {
        profileDocumentsStoreService.getDocument(collection: "users", document: uid) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let userData):
                let name = userData["name"] as? String
                // User profile document exists and contains required fields
                currentUser = UserProfile(
                    id: uid,
                    email: email,
                    name: name,
                    profileImageURL: URL(string: userData["profileImageURL"] as? String ?? "")
                )

                DispatchQueue.main.async {
                    self.presenter?.didFetchUserProfile(self.currentUser!)
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: error)
                }
            }
        }
    }
}

// MARK: - GroupUpdate
extension EditProfileInteractor {
    // Update user profile document (FirebaseFirestore fullName + imageURL + upload an image (Cloudinary) by default)
    private func completeGroupUpdate(name: String, image: Data?) {
        guard let user = currentUser,
              let authUser = authService.currentUser else {
            DispatchQueue.main.async {
                self.presenter?.didFailToFetchData(with: AppError.customError(message: "User is not signed in", comment: ""))
            }

            return
        }

        // Uploade an image and update the user profile document data
        if let newImageData = image {
            uploadProfileImage(imageData: newImageData) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let url):
                    self.updateUserDocumentsData(uid: authUser.id, name: name, profileImageUrl: url.absoluteString)
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.presenter?.didFailToFetchData(with: error)
                    }
                }
            }
        } else if name != user.name {
            // Update name
            let profileImageString = user.profileImageURL?.absoluteString ?? ""
            self.updateUserDocumentsData(uid: authUser.id, name: name, profileImageUrl: profileImageString)
        } else {
            presenter?.didCloseWithNoChanges()
        }
    }
}

// MARK: - UploadToCloudinary
extension EditProfileInteractor {
    // Upload image data to Cloudinary (by default) and then update the Firestore document with the URL
    private func uploadProfileImage(imageData: Data, completion: @escaping (Result<URL, Error>) -> Void) {
        profileDataStoreService.uploadProfileImage(imageData: imageData, completion: completion)
    }
}

// MARK: - UploadToFirestore
extension EditProfileInteractor {
    // Update the user document with the new name and the profile image URL
    private func updateUserDocumentsData(uid: String, name: String, profileImageUrl: String) {
        let data = ["name": name, "profileImageURL": profileImageUrl]
        profileDocumentsStoreService.updateData(collection: "users", document: uid, data: data) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: error)
                }
            } else {
                DispatchQueue.main.async {
                    self.presenter?.didFinishProfileUpdate()
                }
            }
        }
    }
}
