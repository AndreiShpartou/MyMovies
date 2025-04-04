//
//  SignUpInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class SignUpInteractor: SignUpInteractorProtocol {
    weak var presenter: SignUpInteractorOutputProtocol?

    // MARK: - Init
    init(presenter: SignUpInteractorOutputProtocol? = nil) {
        self.presenter = presenter
    }

    // MARK: - Public
    func signUp(email: String, password: String, fullName: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.presenter?.didFailToSignUp(with: error)

                return
            }

            guard let user = result?.user else {
                self.presenter?.didFailToSignUp(with: AppError.unknownError("Unable to create user"))

                return
            }

            // Save to Firestore
            let userData: [String: Any] = [
                "name": fullName
            ]

            // Wait for 0.3 seconds before saving to Firestore
            // In order to allow other scenes to set up their listeners after the user is signed in
            DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.3) {
                Firestore.firestore().collection("users").document(user.uid).setData(userData) { error in
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
}
