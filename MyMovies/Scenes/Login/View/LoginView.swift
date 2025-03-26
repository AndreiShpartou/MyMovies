//
//  LoginView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import UIKit

final class LoginView: UIView, LoginViewProtocol {
    weak var delegate: LoginViewDelegate?

    // MARK: - UIComponents

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func showLoadingIndicator() {
    }

    func hideLoadingIndicator() {
    }

    func showError(error: Error) {
    }
}

// MARK: - Setup
extension LoginView {
    private func setupView() {
    }
}

// MARK: - Constraints
extension LoginView {
    private func setupConstraints() {
    }
}
