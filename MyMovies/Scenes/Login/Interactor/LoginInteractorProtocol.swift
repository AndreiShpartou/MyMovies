//
//  LoginInteractorProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import Foundation

protocol LoginInteractorProtocol: AnyObject {
    var presenter: LoginInteractorOutputProtocol? { get set }

    func signIn(withEmail: String, password: String)
}

protocol LoginInteractorOutputProtocol: AnyObject {
    func didSignInSuccessfully()
    func didFailToSignIn(with error: Error)
}
