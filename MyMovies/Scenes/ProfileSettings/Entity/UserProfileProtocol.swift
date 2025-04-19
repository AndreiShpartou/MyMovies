//
//  UserProfileProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 08/10/2024.
//

import Foundation

protocol UserProfileProtocol: Codable {
    var id: String { get }
    var email: String { get }
    var name: String? { get }
    var profileImageURL: URL? { get }
}
