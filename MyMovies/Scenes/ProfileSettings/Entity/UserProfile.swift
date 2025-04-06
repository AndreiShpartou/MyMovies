//
//  UserProfile.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 08/10/2024.
//

import Foundation

struct UserProfile: UserProfileProtocol {
    let id: String
    var email: String
    var name: String?
    var profileImageURL: URL?
}
