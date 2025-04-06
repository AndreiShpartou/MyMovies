//
//  AuthServiceProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 06/04/2025.
//

import Foundation

protocol AuthServiceProtocol {
    var currentUser: UserProfileProtocol? { get }

    func createUser(withEmail email: String, password: String, completion: @escaping (Result<UserProfileProtocol, Error>) -> Void)
    func signIn(withEmail email: String, password: String, completion: @escaping (Result<UserProfileProtocol, Error>) -> Void)
    func signOut() throws

    func addAuthStateDidChangeListener(_ listener: @escaping (UserProfileProtocol?) -> Void) -> NSObjectProtocol?
    func removeAuthStateDidChangeListener(_ handle: NSObjectProtocol)
}
