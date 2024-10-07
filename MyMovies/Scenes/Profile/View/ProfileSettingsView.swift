//
//  ProfileSettingsView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

final class ProfileSettingsView: UIView, ProfileSettingsViewProtocol {
    weak var delegate: ProfileSettingsInteractionDelegate? {
        didSet {
            updateDelegates()
        }
    }
    var presenter: ProfileSettingsPresenterProtocol?

    // MARK: - UIComponents
    // Header section
    private let headerView: UIView = .createCommonView()
    private let profileImageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFill,
        clipsToBounds: true,
        cornerRadius: 40,
        image: Asset.Avatars.avatarMock.image
    )
    private let nameLabel: UILabel = .createLabel(
        font: Typography.SemiBold.title,
        textColor: .textColorWhite,
        text: "Smith"
    )
    private let emailLabel: UILabel = .createLabel(
        font: Typography.Regular.subhead,
        textColor: .textColorGrey,
        text: "AgentSmithMatrix@gmail.com"
    )
    private lazy var editButton: UIButton = createEditButton()

    // Settings Table
    private lazy var tableView: UITableView = createSettingsTableView()
    // Indicators
    private let loadingIndicator: UIActivityIndicatorView = .createSpinner(style: .large)

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
    func showError(_ message: String) {
        guard let viewController = parentViewController else {
            return
        }

        // Present an alert to the user
        let alert = UIAlertController(
            title: NSLocalizedString("Error", comment: "Error alert title"),
            message: message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: NSLocalizedString("OK", comment: "OK button title"),
            style: .default
        )
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }

    func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }

    // MARK: - Presentation logic
//    func showUserProfile(_ profile: UserProfileViewModelProtocol) {
//        profileImageView.kf.setImage(with: profile.profileImageURL, placeholder: Asset.DefaultCovers.defaultProfile.image)
//        nameLabel.text = profile.name
//        emailLabel.text = profile.email
//    }

//    func showSettingsItems(_ items: [ProfileSettingsSectionViewModelProtocol]) {
//        tableView.reloadData()
//    }
}

// MARK: - Setup
extension ProfileSettingsView {
    private func setupView() {
        backgroundColor = .primaryBackground
    }

    private func updateDelegates() {
    }
}

// MARK: - ActionMethods
extension ProfileSettingsView {
    @objc
    private func editButtonTapped() {
        delegate?.didTapEditProfile()
    }
}

// MARK: - Helpers
extension ProfileSettingsView {
    private func createEditButton() -> UIButton {
        let button = UIButton(type: .system)
        let editImage = Asset.Icons.edit.image.withRenderingMode(.alwaysTemplate).withTintColor(.primaryBlueAccent)
        button.setImage(editImage, for: .normal)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)

        return button
    }

    private func createSettingsTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
//        tableView.register(ProfileSettingsTableViewCell.self, forCellReuseIdentifier: ProfileSettingsTableViewCell.identifier)
        tableView.separatorStyle = .none

        return tableView
    }
}

// MARK: - Constraints
extension ProfileSettingsView {
    private func setupConstraints() {
    }
}
