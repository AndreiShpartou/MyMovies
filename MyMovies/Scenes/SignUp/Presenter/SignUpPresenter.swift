//
//  SignUpPresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import Foundation

final class SignUpPresenter: SignUpPresenterProtocol {
    weak var view: SignUpViewProtocol?
    var interactor: SignUpInteractorProtocol
    var router: SignUpRouterProtocol

    // MARK: - Init
    init(view: SignUpViewProtocol? = nil, interactor: SignUpInteractorProtocol, router: SignUpRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    // MARK: - Public
    func viewDidLoad() {
    }

    func didTapSignUpButton(email: String, password: String, fullName: String) {
        view?.setLoadingIndicator(isVisible: true)

        interactor.signUp(email: email, password: password, fullName: fullName)
    }
}

// MARK: - LoginInteractorOutputProtocol
extension SignUpPresenter: SignUpInteractorOutputProtocol {
    func didSignUpSuccessfully() {
        view?.setLoadingIndicator(isVisible: false)
    }

    func didFailToSignUp(with error: Error) {
        let appError = ErrorManager.toAppError(error)
        view?.showError(with: ErrorManager.toUserMessage(from: appError))

        view?.setLoadingIndicator(isVisible: false)
    }
}
