//
//  CloudinaryService.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 31/03/2025.
//

import Cloudinary

class CloudinaryService: ProfileDataStoreServiceProtocol {
    private let cloudinary: CLDCloudinary

    init(configuration: CLDConfiguration = CLDConfiguration(cloudName: "dfe1lkbwt", apiKey: "445626447662862", apiSecret: "eUa65FGYdWeil5iwYk6shtcENso")) {
        self.cloudinary = CLDCloudinary(configuration: configuration)
    }

    // Upload image data to Cloudinary
    func uploadProfileImage(imageData: Data, completion: @escaping (Result<URL, Error>) -> Void) {
        let uploader = cloudinary.createUploader()
        uploader.upload(data: imageData, uploadPreset: "profile_images", completionHandler: { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let result = result,
                      let secureUrlString = result.secureUrl,
                      let secureUrl = URL(string: secureUrlString) {
                completion(.success(secureUrl))
            } else {
                completion(.failure(AppError.customError(message: "Failed to upload image", comment: "")))
            }
        })
    }
}
