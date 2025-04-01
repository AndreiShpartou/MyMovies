//
//  LoginPresenterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import Foundation

protocol LoginPresenterProtocol: AnyObject, LoginInteractorOutputProtocol {
    var view: LoginViewProtocol? { get set }
    var interactor: LoginInteractorProtocol { get set }
    var router: LoginRouterProtocol { get set }

    func viewDidLoad()
    func didTapSignInButton(email: String, password: String)
    func didTapSignUpButton()
    func didTapBackButton()
}
