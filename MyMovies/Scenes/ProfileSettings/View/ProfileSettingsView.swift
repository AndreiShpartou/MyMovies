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

    // MARK: - UIComponents
    private let scrollView = UIScrollView()
    private let contentView: UIView = .createCommonView()
    // Header section
    private let headerView: UIView = .createCommonView(
        cornerRadius: 20,
        borderWidth: 2,
        borderColor: UIColor.primarySoft.cgColor
    )

    private let profileImageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFill,
        clipsToBounds: true,
        cornerRadius: 30,
        image: Asset.Avatars.avatarDefault.image
    )

    private let nameLabel: UILabel = .createLabel(
        font: Typography.SemiBold.title,
        textColor: .textColorWhite
    )

    private let emailLabel: UILabel = .createLabel(
        font: Typography.Regular.subhead,
        textColor: .textColorGrey
    )

    private lazy var editButton: UIButton = createEditButton()

    private let guestUserView: UIView = .createCommonView(
        backgroundColor: .primaryBackground,
        isHidden: false
    )

    private lazy var signInButton = UIButton(
        title: "Sign In",
        font: Typography.Medium.title,
        titleColor: .textColorWhite,
        backgroundColor: .primarySoft,
        cornerRadius: Sizes.Medium.cornerRadius,
        action: #selector(didTapSignInButton),
        target: self
    )

    private lazy var signOutButton = UIButton(
        title: "Sign Out",
        font: Typography.Medium.title,
        titleColor: .secondaryRed,
        backgroundColor: .primarySoft,
        cornerRadius: Sizes.Medium.cornerRadius,
        action: #selector(didTapSignOutButton),
        target: self
    )

    // Settings Table
    private lazy var tableView: UITableView = createSettingsTableView()
    private let tableViewHandler = ProfileSettingsTableViewHandler()
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
    func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }

    // MARK: - Presentation logic
    func showUserProfile(_ profile: UserProfileViewModelProtocol) {
        profileImageView.kf.setImage(with: profile.profileImageURL, placeholder: Asset.Avatars.signedUser.image)
        nameLabel.text = profile.name
        emailLabel.text = profile.email
        showLoggedInViews()
        hideLoadingIndicator()
    }

    func showSettingsItems(_ items: [ProfileSettingsSectionViewModelProtocol]) {
        tableViewHandler.configure(with: items)
        tableView.reloadData()
        hideLoadingIndicator()
    }

    func showSignOutItems() {
        showLoggedOutViews()
        hideLoadingIndicator()
    }

    func showError(_ error: Error) {
        guard let viewController = parentViewController else {
            return
        }

        // Present an alert to the user
        let alert = getGlobalAlertController(for: error.localizedDescription)
        viewController.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Setup
extension ProfileSettingsView {
    private func setupView() {
        backgroundColor = .primaryBackground
        addSubviews(scrollView)
        scrollView.addSubviews(contentView, loadingIndicator)
        contentView.addSubviews(headerView, tableView, signOutButton)
        headerView.addSubviews(
            profileImageView,
            nameLabel,
            emailLabel,
            editButton,
            guestUserView
        )
        guestUserView.addSubviews(signInButton)

        setupSubviews()
        setupGestureRecognizers()
    }

    private func updateDelegates() {
        tableViewHandler.delegate = delegate
    }

    private func setupSubviews() {
        showLoggedOutViews()
    }

    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerViewTapped))
        headerView.addGestureRecognizer(tapGesture)
        headerView.isUserInteractionEnabled = true
    }

    private func showLoggedOutViews() {
        nameLabel.isHidden = true
        emailLabel.isHidden = true
        editButton.isHidden = true
        signOutButton.isHidden = true
        guestUserView.isHidden = false
        signInButton.isHidden = false
        profileImageView.image = Asset.Avatars.avatarDefault.image
        nameLabel.text = nil
        emailLabel.text = nil
    }

    private func showLoggedInViews() {
        nameLabel.isHidden = false
        emailLabel.isHidden = false
        editButton.isHidden = false
        signOutButton.isHidden = false
        guestUserView.isHidden = true
        signInButton.isHidden = true
    }
}

// MARK: - ActionMethods
extension ProfileSettingsView {
    @objc
    private func headerViewTapped() {
        guard !signOutButton.isHidden else {
            return
        }

        delegate?.didTapEditProfile()
    }

    @objc
    private func didTapSignInButton() {
        delegate?.didTapSignIn()
    }

    @objc
    private func didTapSignOutButton() {
        delegate?.didTapSignOut()
    }
}

// MARK: - Helpers
extension ProfileSettingsView {
    private func createEditButton() -> UIButton {
        let button = UIButton(type: .system)
        let editImage = Asset.Icons.edit.image.withTintColor(.primaryBlueAccent, renderingMode: .alwaysOriginal)
        button.setImage(editImage, for: .normal)

        return button
    }

    private func createSettingsTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(ProfileSettingsTableViewCell.self, forCellReuseIdentifier: ProfileSettingsTableViewCell.identifier)
        tableView.backgroundColor = .primaryBackground
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.allowsSelection = true
        tableView.layer.cornerRadius = 12
        tableView.clipsToBounds = true
        tableView.allowsMultipleSelection = false

        tableView.dataSource = tableViewHandler
        tableView.delegate = tableViewHandler

        return tableView
    }
}

// MARK: - Constraints
extension ProfileSettingsView {
    private func setupConstraints() {
        setupScrollConstraints()
        setupHeaderConstraints()
        setupTableViewConstraints()
        setupFooterConstraints()
    }

    private func setupScrollConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }

        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func setupHeaderConstraints() {
        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(100)
        }

        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }

        editButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.equalTo(editButton.snp.leading).offset(-8)
            make.top.equalTo(profileImageView).offset(8)
        }

        emailLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }

        guestUserView.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(editButton)
            make.top.bottom.equalToSuperview().inset(12)
        }

        signInButton.snp.makeConstraints { make in
            make.edges.equalTo(guestUserView).inset(12)
        }
    }

    private func setupTableViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(headerView.snp.bottom).offset(8)
            make.height.equalTo(450)
        }
    }

    private func setupFooterConstraints() {
        signOutButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(tableView.snp.bottom).offset(24)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
