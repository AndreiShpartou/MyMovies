//
//  SignUpPresenterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import Foundation

protocol SignUpPresenterProtocol: AnyObject, SignUpInteractorOutputProtocol {
    var view: SignUpViewProtocol? { get set }
    var interactor: SignUpInteractorProtocol { get set }
    var router: SignUpRouterProtocol { get set }

    func viewDidLoad()
    func didTapSignUpButton(email: String, password: String, fullName: String)
}
