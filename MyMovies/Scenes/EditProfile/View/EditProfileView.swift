//
//  EditProfileView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/10/2024.
//

import UIKit

final class EditProfileView: UIView, EditProfileViewProtocol {
    weak var delegate: EditProfileInteractionDelegate?
    var presenter: EditProfilePresenterProtocol?

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
    func showUserProfile(_ profile: UserProfileViewModelProtocol) {
        //
    }

    func showError(_ message: String) {
        //
    }

    func showLoadingIndicator() {
        //
    }

    func hideLoadingIndicator() {
        //
    }
}

// MARK: - Setup
extension EditProfileView {
    private func setupView() {
    }
}

// MARK: - Constraints
extension EditProfileView {
    private func setupConstraints() {
    }
}
