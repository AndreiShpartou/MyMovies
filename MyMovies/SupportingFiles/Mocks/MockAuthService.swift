//
//  MockAuthService.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 07/04/2025.
//
import Foundation

// MARK: - MockAuthService
final class MockAuthService: AuthServiceProtocol {
    var currentUser: UserProfile?

    var didCallCreateUser = false
    var didCallSignIn = false
    var didCallSignOut = false
    var capturedEmail: String?
    var capturedPassword: String?

    var shouldFailOnCreateUser = ProcessInfo.processInfo.arguments.contains("MockAuthService_shouldFailOnCreateUser")
    var shouldFailOnSignIn = ProcessInfo.processInfo.arguments.contains("MockAuthService_shouldFailOnSignIn")
    var shouldFailOnSignOut = false

    // MARK: - AuthServiceProtocol
    func createUser(withEmail email: String, password: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        didCallCreateUser = true
        capturedEmail = email
        capturedPassword = password

        if shouldFailOnCreateUser {
            completion(.failure(AppError.customError(message: "Failed to create user", comment: "")))
        } else {
            completion(.success(UserProfile(id: "Mock_id", email: email, name: "MockUserName")))
        }
    }

    func signIn(withEmail email: String, password: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        didCallSignIn = true
        capturedEmail = email
        capturedPassword = password

        if shouldFailOnSignIn {
            completion(.failure(AppError.customError(message: "Failed to sign in", comment: "")))
        } else {
            completion(.success(UserProfile(id: "Mock_id", email: email, name: "MockUserName")))
        }
    }

    func signOut() throws {
        didCallSignOut = true

        if shouldFailOnSignOut {
            throw AppError.customError(message: "Failed to sign out", comment: "")
        }
    }

    // Observers
    func addAuthStateDidChangeListener(_ listener: @escaping (UserProfile?) -> Void) -> NSObjectProtocol? { return nil }
    func removeAuthStateDidChangeListener(_ handle: NSObjectProtocol) {}
}
