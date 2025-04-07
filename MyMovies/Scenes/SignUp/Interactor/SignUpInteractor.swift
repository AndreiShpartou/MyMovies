//
//  SignUpInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import Foundation

final class SignUpInteractor: SignUpInteractorProtocol {
    weak var presenter: SignUpInteractorOutputProtocol?

    private let authService: AuthServiceProtocol
    private let profileDocumentsStoreService: ProfileDocumentsStoreServiceProtocol

    // MARK: - Init
    init(
        authService: AuthServiceProtocol = FirebaseAuthService(),
        profileDocumentsStoreService: ProfileDocumentsStoreServiceProtocol = FirebaseFirestoreService(),
        presenter: SignUpInteractorOutputProtocol? = nil
    ) {
        self.authService = authService
        self.profileDocumentsStoreService = profileDocumentsStoreService
        self.presenter = presenter
    }

    // MARK: - Public
    func signUp(email: String, password: String, fullName: String) {
        authService.createUser(withEmail: email, password: password) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let userProfile):
                self.createUserProfileDocument(id: userProfile.id, name: fullName)
            case .failure(let error):
                self.presenter?.didFailToSignUp(with: error)
            }
        }
    }
}

// MARK: - Private
extension SignUpInteractor {
    // Create the user profile document
    // Store user profile full name to the Firestore (by default)
    private func createUserProfileDocument(id: String, name: String) {
        // Wait for 0.3 seconds before saving to Firestore
        // In order to allow other scenes to set up their listeners after the user is signed in
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.3) {
            self.profileDocumentsStoreService.setData(collection: "users", document: id, data: ["name": name]) { error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.presenter?.didFailToSignUp(with: error)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.presenter?.didSignUpSuccessfully()
                    }
                }
            }
        }
    }
}
