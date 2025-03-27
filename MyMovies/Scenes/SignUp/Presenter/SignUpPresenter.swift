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

    func didTapSignUpButton() {
    }
}

// MARK: - LoginInteractorOutputProtocol
extension SignUpPresenter: SignUpInteractorOutputProtocol {
    func didSignUpSuccessfully() {
    }
}
