//
//  ProfileView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

class ProfileView: UIView {
    var presenter: ProfilePresenterProtocol?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
extension ProfileView {
    private func setupView() {
        backgroundColor = .primaryBackground
    }
}

// MARK: - Constraints
extension ProfileView {
    private func setupConstraints() {
    }
}
