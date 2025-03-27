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
        cornerRadius: 30
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
    func showError(_ message: String) {
        guard let viewController = parentViewController else {
            return
        }

        // Present an alert to the user
        let alert = getGlobalAlertController(for: message)
        viewController.present(alert, animated: true, completion: nil)
    }

    func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }

    // MARK: - Presentation logic
    func showUserProfile(_ profile: UserProfileViewModelProtocol) {
        profileImageView.kf.setImage(with: profile.profileImageURL, placeholder: Asset.Avatars.avatarDefault.image)
        nameLabel.text = profile.name
        emailLabel.text = profile.email

        nameLabel.isHidden = false
        emailLabel.isHidden = false
        editButton.isHidden = false

        hideLoadingIndicator()
    }

    func signOut() {
        delegate?.didTapSignOut()

        guestUserView.isHidden = true
        signInButton.isHidden = true
    }

    func showSettingsItems(_ items: [ProfileSettingsSectionViewModelProtocol]) {
        tableViewHandler.configure(with: items)
        tableView.reloadData()
        hideLoadingIndicator()
    }
}

// MARK: - Setup
extension ProfileSettingsView {
    private func setupView() {
        backgroundColor = .primaryBackground
        addSubviews(scrollView)
        scrollView.addSubviews(contentView, loadingIndicator)
        contentView.addSubviews(headerView, tableView)
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
        nameLabel.isHidden = true
        emailLabel.isHidden = true
        editButton.isHidden = true
        guestUserView.isHidden = false
        signInButton.isHidden = false
    }

    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerViewTapped))
        headerView.addGestureRecognizer(tapGesture)
        headerView.isUserInteractionEnabled = true
    }
}

// MARK: - ActionMethods
extension ProfileSettingsView {
    @objc
    private func headerViewTapped() {
        delegate?.didTapEditProfile()
    }

    @objc
    private func didTapSignInButton() {
        delegate?.didTapSignIn()
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
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
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
            make.top.bottom.equalToSuperview().inset(8)
        }

        signInButton.snp.makeConstraints { make in
            make.edges.equalTo(guestUserView).inset(12)
        }
    }

    private func setupTableViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(headerView.snp.bottom).offset(8)
            make.height.equalTo(500)
            make.bottom.equalToSuperview()
        }
    }
}
