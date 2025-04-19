//
//  ProfileDataStoreServiceProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 06/04/2025.
//

import Foundation

protocol ProfileDataStoreServiceProtocol {
    func uploadProfileImage(imageData: Data, completion: @escaping (Result<URL, Error>) -> Void)
}
