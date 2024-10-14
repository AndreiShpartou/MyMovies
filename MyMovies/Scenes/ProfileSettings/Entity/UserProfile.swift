//
//  UserProfile.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 08/10/2024.
//

import Foundation

struct UserProfile: UserProfileProtocol {
    let id: Int
    let name: String
    let email: String
    let profileImageURL: URL?
}
