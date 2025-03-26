//
//  LoginPresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import Foundation

final class LoginPresenter: LoginPresenterProtocol {
    weak var view: LoginViewProtocol?
    var interactor: LoginInteractorProtocol
    var router: LoginRouterProtocol

    // MARK: - Init
    init(interactor: LoginInteractorProtocol, router: LoginRouterProtocol, view: LoginViewProtocol? = nil) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }

    // MARK: - Public
    func viewDidLoad() {
    }

    func didTapLoginButton() {
    }

    func didTapSignUpButton() {
    }
}

// MARK: - LoginInteractorOutputProtocol
extension LoginPresenter {
    func didLoginSuccessfully() {
    }
}
