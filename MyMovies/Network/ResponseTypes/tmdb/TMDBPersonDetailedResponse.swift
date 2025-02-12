//
//  TMDBPersonDetailedResponse.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/02/2025.
//

import Foundation

struct TMDBPersonDetailedResponse: TMDBPersonDetailedResponseProtocol {
    var id: Int
    var name: String
    var birthday: String?
    var place_of_birth: String?
    var deathday: String?
    var known_for_department: String?
    var profile_path: String?

    func personPhotoURL(path: String?, size: PersonSize = .w185) -> String? {
        guard let path = path else {
            return nil
        }

        return ImageURLBuilder.buildURL(for: path, size: size)
    }
}
