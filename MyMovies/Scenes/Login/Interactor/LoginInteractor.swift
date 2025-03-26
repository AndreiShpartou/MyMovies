//
//  LoginInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import Foundation

final class LoginInteractor: LoginInteractorProtocol {
    weak var presenter: LoginInteractorOutputProtocol?

    init(presenter: LoginInteractorOutputProtocol? = nil) {
        self.presenter = presenter
    }

    // MARK: - Public
    func login(email: String, password: String) {
        presenter?.didLoginSuccessfully()
    }
}
