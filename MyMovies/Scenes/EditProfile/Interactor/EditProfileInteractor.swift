//
//  EditProfileInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/10/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Kingfisher

final class EditProfileInteractor: EditProfileInteractorProtocol {
    weak var presenter: EditProfileInteractorOutputProtocol?

    private let networkManager: NetworkManagerProtocol
    private let cloudinaryManager: CloudinaryManagerProtocol
    private let firestoreDB = Firestore.firestore()

    private var currentUser: UserProfileProtocol?
    private var currentUserProfileImage: UIImage?

    // MARK: - Init
    init(
        networkManager: NetworkManagerProtocol = NetworkManager.shared,
        cloudinaryManager: CloudinaryManagerProtocol = CloudinaryManager.shared
    ) {
        self.networkManager = networkManager
        self.cloudinaryManager = cloudinaryManager
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

    func updateUserProfile(name: String, image: UIImage?) {
        completeGroupUpdate(name: name, image: image)
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

            // Return if data wasn't stored -> Wait until it'll be stored and fetching be triggered by the listener
            guard let name = userData["name"] as? String else {
                return
            }

            let profileImageURL = userData["profileImageURL"] as? URL
            currentUser = UserProfile(
                id: uid,
                name: name,
                email: email,
                profileImageURL: profileImageURL
            )

            // Fetch profile image
            self.fetchProfileImageFromCache(url: profileImageURL)

            // Update UI
            DispatchQueue.main.async {
                self.presenter?.didFetchUserProfile(self.currentUser!)
            }
        }
    }
}

// MARK: - GroupUpdate
extension EditProfileInteractor {
    // Update FirebaseFirestore fullName + imageURL + email + upload an image (Cloudinary)
    private func completeGroupUpdate(name: String, image: UIImage?) {
        guard let user = currentUser,
              let authUser = Auth.auth().currentUser else {
            return
        }

        let dispatchGroup = DispatchGroup()
        // Update fullName
        if name != user.name {
            dispatchGroup.enter()
            updateUserName(uid: authUser.uid, name: name) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    break
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.presenter?.didFailToFetchData(with: error)
                    }
                }
                dispatchGroup.leave()
            }
        }
        // Update an image
        if let currentImage = currentUserProfileImage,
           let newImage = image,
           let newImageData = newImage.pngData(),
           !currentImage.isEqualToImage(newImage) {
            dispatchGroup.enter()
            uploadProfileImage(imageData: newImageData) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let url):
                    dispatchGroup.enter()
                    self.updateUserProfileImage(uid: authUser.uid, profileImageUrl: url.absoluteString) { result in
                        switch result {
                        case .success:
                            break
                        case .failure(let error):
                            DispatchQueue.main.async {
                                self.presenter?.didFailToFetchData(with: error)
                            }
                        }
                        dispatchGroup.leave()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.presenter?.didFailToFetchData(with: error)
                    }
                }
                dispatchGroup.leave()
            }
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
            } else if let result = result, let secureUrlString = result.secureUrl, let secureUrl = URL(string: secureUrlString) {
                completion(.success(secureUrl))
            } else {
                completion(.failure(NSError(domain: "UploadError", code: 0, userInfo: nil)))
            }
        })
    }
}

// MARK: - UploadToFirestore
extension EditProfileInteractor {
    // Update the Firestore document with the new name
    private func updateUserName(uid: String, name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreDB.collection("users").document(uid).updateData(["name": name]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // Update the Firestore document with the new profile image URL
    private func updateUserProfileImage(uid: String, profileImageUrl: String, completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreDB.collection("users").document(uid).updateData(["profileImageUrl": profileImageUrl]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

// MARK: - Helpers
extension EditProfileInteractor {
    private func fetchProfileImageFromCache(url: URL?) {
        guard let absoluteString = url?.absoluteString else {
            self.currentUserProfileImage = Asset.Avatars.signedUser.image

            return
        }

        ImageCache.default.retrieveImage(forKey: absoluteString) { result in
            switch result {
            case.success(let value):
                self.currentUserProfileImage = value.image
            case .failure(let error):
                print(error)
            }
        }
    }
}
