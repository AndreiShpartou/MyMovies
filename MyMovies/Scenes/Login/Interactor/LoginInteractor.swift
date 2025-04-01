//
//  LoginInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import Foundation
import FirebaseAuth

final class LoginInteractor: LoginInteractorProtocol {
    weak var presenter: LoginInteractorOutputProtocol?

    init(presenter: LoginInteractorOutputProtocol? = nil) {
        self.presenter = presenter
    }

    // MARK: - Public
    func signIn(withEmail: String, password: String) {
        Auth.auth().signIn(withEmail: withEmail, password: password) { [weak self] _, error in
            guard let self = self else { return }

            if let error = error {
                self.presenter?.didFailToSignIn(with: error)

                return
            }

            self.presenter?.didSignInSuccessfully()
        }
    }
}
