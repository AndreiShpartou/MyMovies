//
//  SignUpInteractorProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import Foundation

protocol SignUpInteractorProtocol: AnyObject {
    var presenter: SignUpInteractorOutputProtocol? { get set }

    func signUp(email: String, password: String, fullName: String)
}

protocol SignUpInteractorOutputProtocol: AnyObject {
    func didSignUpSuccessfully()
    func didFailToSignUp(with error: Error)
}
