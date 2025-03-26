//
//  SignUpViewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import UIKit

protocol SignUpViewProtocol: UIView {
    var delegate: SignUpViewDelegate? { get set }

    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showError(error: Error)
}

protocol SignUpViewDelegate: AnyObject {
    func didTapSignUpButton()
}
