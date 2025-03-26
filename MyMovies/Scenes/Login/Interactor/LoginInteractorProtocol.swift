//
//  LoginInteractorProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import Foundation

protocol LoginInteractorProtocol: AnyObject {
    var presenter: LoginInteractorOutputProtocol? { get set }

    func login(email: String, password: String)
}

protocol LoginInteractorOutputProtocol: AnyObject {
    func didLoginSuccessfully()
}
