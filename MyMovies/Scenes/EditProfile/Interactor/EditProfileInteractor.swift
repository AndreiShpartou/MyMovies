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

    private let cloudinaryManager: CloudinaryServiceProtocol
    private let firestoreDB = Firestore.firestore()

    // Store the fetched user profile
    private var currentUser: UserProfileProtocol?

    // MARK: - Init
    init(cloudinaryManager: CloudinaryServiceProtocol = CloudinaryService.shared) {
        self.cloudinaryManager = cloudinaryManager
    }

    // MARK: - EditProfileInteractorProtocol
    func fetchUserProfile() {
        guard let user = Auth.auth().currentUser,
              let email = user.email else {
            DispatchQueue.main.async {
                self.presenter?.didFailToFetchData(with: AppError.customError(message: "User is not signed in", comment: ""))
            }

            return
        }

        // Fetch full data and update UI if user is signed in
        fetchAdditionalUserData(uid: user.uid, email: email)
    }

    // Update the user's profile in the Firestore (and upload a new image if provided)
    func updateUserProfile(name: String, profileImage: Data?) {
        completeGroupUpdate(name: name, image: profileImage)
    }
}

// MARK: - Private FetchData
extension EditProfileInteractor {
    // Fetch user data from FirebaseFirestore
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

            // Return if data wasn't stored
            guard let name = userData["name"] as? String else {
                return
            }

            currentUser = UserProfile(
                id: uid,
                name: name,
                email: email,
                profileImageURL: URL(string: (userData["profileImageURL"] as? String ?? ""))
            )

            // Update UI
            DispatchQueue.main.async {
                self.presenter?.didFetchUserProfile(self.currentUser!)
            }
        }
    }
}

// MARK: - GroupUpdate
extension EditProfileInteractor {
    // Update FirebaseFirestore fullName + imageURL + upload an image (Cloudinary)
    private func completeGroupUpdate(name: String, image: Data?) {
        guard let user = currentUser,
              let authUser = Auth.auth().currentUser else {
            DispatchQueue.main.async {
                self.presenter?.didFailToFetchData(with: AppError.customError(message: "User is not authenticated", comment: ""))
            }

            return
        }

        // Uploade an image and update Firestore data
        if let newImageData = image {
            uploadProfileImage(imageData: newImageData) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let url):
                    self.updateFirestoreData(uid: authUser.uid, name: name, profileImageUrl: url.absoluteString)
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.presenter?.didFailToFetchData(with: error)
                    }
                }
            }
        } else if name != user.name {
            // Update name
            let profileImageString = user.profileImageURL?.absoluteString ?? ""
            self.updateFirestoreData(uid: authUser.uid, name: name, profileImageUrl: profileImageString)
        } else {
            presenter?.didCloseWithNoChanges()
        }
    }
}

// MARK: - UploadToCloudinary
extension EditProfileInteractor {
    // Upload image data to Cloudinary and then update the Firestore document with the URL
    private func uploadProfileImage(imageData: Data, completion: @escaping (Result<URL, Error>) -> Void) {
        // Create an uploader
        let uploader = cloudinaryManager.cloudinary.createUploader()

        uploader.upload(data: imageData, uploadPreset: "profile_images", completionHandler: { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let result = result,
                      let secureUrlString = result.secureUrl,
                      let secureUrl = URL(string: secureUrlString) {
                completion(.success(secureUrl))
            } else {
                completion(.failure(NSError(domain: "UploadError", code: 0, userInfo: nil)))
            }
        })
    }
}

// MARK: - UploadToFirestore
extension EditProfileInteractor {
    // Update the Firestore document with the new name and the profile image URL
    private func updateFirestoreData(uid: String, name: String, profileImageUrl: String) {
        firestoreDB.collection("users").document(uid).updateData(["name": name, "profileImageURL": profileImageUrl]) { [weak self] error in
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
