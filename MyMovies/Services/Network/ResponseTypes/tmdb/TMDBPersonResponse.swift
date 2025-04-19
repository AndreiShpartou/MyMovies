//
//  TMDBPersonResponse.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 16/12/2024.
//

import Foundation

struct TMDBPersonResponse: TMDBPersonResponseProtocol {
    var id: Int
    var name: String
    var original_name: String
    var profile_path: String?
    var known_for_department: String?
    var popularity: Float?

    func personPhotoURL(path: String?, size: PersonSize = .w185) -> String? {
        guard let path = path else {
            return nil
        }

        return ImageURLBuilder.buildURL(for: path, size: size)
    }
}
