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
    init(view: LoginViewProtocol? = nil, interactor: LoginInteractorProtocol, router: LoginRouterProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }

    // MARK: - Public
    func viewDidLoad() {
    }

    func didTapSignInButton(email: String, password: String) {
        view?.setLoadingIndicator(isVisible: true)
        interactor.signIn(withEmail: email, password: password)
    }

    func didTapSignUpButton() {
        router.navigateToSignUp()
    }

    func didTapBackButton() {
        router.dismissScene()
    }
}

// MARK: - LoginInteractorOutputProtocol
extension LoginPresenter {
    func didSignInSuccessfully() {
        view?.setLoadingIndicator(isVisible: false)
    }

    func didFailToSignIn(with error: Error) {
        let appError = ErrorManager.toAppError(error)
        view?.showError(with: ErrorManager.toUserMessage(from: appError))

        view?.setLoadingIndicator(isVisible: false)
    }
}
