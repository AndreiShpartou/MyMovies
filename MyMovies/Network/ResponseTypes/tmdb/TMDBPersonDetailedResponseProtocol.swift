//
//  TMDBPersonDetailedResponseProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/02/2025.
//

import Foundation

protocol TMDBPersonDetailedResponseProtocol: Codable {
    var id: Int { get }
    var name: String { get }
    var birthday: String? { get }
    var place_of_birth: String? { get }
    var deathday: String? { get }
    var known_for_department: String? { get }
    var profile_path: String? { get }

    func personPhotoURL(path: String?, size: PersonSize) -> String?
}
