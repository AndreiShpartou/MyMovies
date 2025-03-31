//
//  CloudinaryManager.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 31/03/2025.
//

import Cloudinary

class CloudinaryManager {
    static let shared = CloudinaryManager()
    
    let cloudinary: CLDCloudinary
    
    private init() {
        let config = CLDConfiguration(cloudName: "dfe1lkbwt", apiKey: "445626447662862", apiSecret: "eUa65FGYdWeil5iwYk6shtcENso")
        self.cloudinary = CLDCloudinary(configuration: config)
    }
}
