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
    init(interactor: SignUpInteractorProtocol, router: SignUpRouterProtocol, view: SignUpViewProtocol? = nil) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }

    // MARK: - Public
    func viewDidLoad() {
    }

    func didTapSignUpButton() {
    }
}

// MARK: - LoginInteractorOutputProtocol
extension SignUpPresenter: SignUpInteractorOutputProtocol {
    func didSignUpSuccessfully() {
    }
}
