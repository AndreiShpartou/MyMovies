//
//  SignUpViewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import UIKit

protocol SignUpViewProtocol: UIView, UIViewKeyboardScrollHandlingProtocol {
    var delegate: SignUpViewDelegate? { get set }

    func setLoadingIndicator(isVisible: Bool)
    func showError(error: Error)
}

protocol SignUpViewDelegate: AnyObject, UITextFieldDelegate {
    func didTapSignUpButton(email: String, password: String, fullName: String)
}
