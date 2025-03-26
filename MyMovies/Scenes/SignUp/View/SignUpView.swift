//
//  SignUpView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import UIKit

final class SignUpView: UIView, SignUpViewProtocol {
    weak var delegate: SignUpViewDelegate? {
        didSet {
            updateDelegates()
        }
    }

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
extension SignUpView {
    private func setupView() {
    }

    private func updateDelegates() {
        //
    }
}

// MARK: - Constraits
extension SignUpView {
    private func setupConstraints() {
    }
}
