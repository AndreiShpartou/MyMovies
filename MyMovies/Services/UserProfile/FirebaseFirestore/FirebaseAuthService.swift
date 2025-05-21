//
//  FirebaseAuthService.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 06/04/2025.
//

import FirebaseAuth

final class FirebaseAuthService: AuthServiceProtocol {
    // MARK: - AuthServic
    var currentUser: UserProfile? {
        guard let user = Auth.auth().currentUser,
              let email = user.email else {
            return nil
        }

        return UserProfile(id: user.uid, email: email)
    }

    func createUser(withEmail email: String, password: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user,
                      let email = user.email {
                completion(.success(UserProfile(id: user.uid, email: email)))
            } else {
                completion(.failure(AppError.customError(message: "Failed to create user", comment: "")))
            }
        }
    }

    func signIn(withEmail email: String, password: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user,
                      let email = user.email {
                completion(.success(UserProfile(id: user.uid, email: email)))
            } else {
                completion(.failure(AppError.customError(message: "Failed to sign in", comment: "")))
            }
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    // MARK: - Observers
    @discardableResult
    func addAuthStateDidChangeListener(_ listener: @escaping (UserProfile?) -> Void) -> NSObjectProtocol? {
        return Auth.auth().addStateDidChangeListener { _, user in
            guard let user = user,
                  let email = user.email else {
                listener(nil)

                return
            }

            listener(UserProfile(id: user.uid, email: email))
        }
    }

    func removeAuthStateDidChangeListener(_ handle: NSObjectProtocol) {
        Auth.auth().removeStateDidChangeListener(handle)
    }
}
