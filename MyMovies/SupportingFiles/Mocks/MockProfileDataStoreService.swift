//
//  MockProfileDataStoreService.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 07/04/2025.
//
import Foundation

// MARK: - MockProfileDataStoreService
final class MockProfileDataStoreService: ProfileDataStoreServiceProtocol {
    var didCallUploadProfileImage = false
    var shouldFailOnUploadProfileImage = false

    // MARK: - ProfileDataStoreServiceProtocol
    func uploadProfileImage(imageData: Data, completion: @escaping (Result<URL, Error>) -> Void) {
        didCallUploadProfileImage = true

        if shouldFailOnUploadProfileImage {
            completion(.failure(AppError.customError(message: "Failed to upload profile image", comment: "")))
        } else {
            completion(.success(URL(string: "https://res.cloudinary.com/dfe1lkbwt/image/upload/v1743262658/cld-sample.jpg")!))
        }
    }
}
