//
//  LoginViewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import UIKit

protocol LoginViewProtocol: UIView, UIViewKeyboardScrollHandlingProtocol {
    var delegate: LoginViewDelegate? { get set }

    func setLoadingIndicator(isVisible: Bool)
    func showError(with message: String)
}

protocol LoginViewDelegate: AnyObject, UITextFieldDelegate {
    func didTapSignInButton(email: String, password: String)
    func didTapSignUpButton()
    func didTapBackButton()
}
