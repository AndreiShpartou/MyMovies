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

    // MARK: - UIComponents
    private let profileImageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFill,
        clipsToBounds: true,
        cornerRadius: 50
    )
    // Header
    private let editBackgroundView: UIView = .createCommonView(cornerRadius: 20, backgroundColor: .primarySoft)
    private let editIconImageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFit,
        cornerRadius: 8,
        image: Asset.Icons.editProfileImage.image.withTintColor(.primaryBlueAccent, renderingMode: .alwaysOriginal),
        backgroundColor: .primarySoft
    )

    private let fullNameLabel: UILabel = .createLabel(
        font: Typography.SemiBold.title,
        textAlignment: .center,
        textColor: .textColorWhite
    )

    private let emailLabel: UILabel = .createLabel(
        font: Typography.Medium.subhead,
        textAlignment: .center,
        textColor: .textColorGrey
    )
    // Body with text fields
    // FullName
    private let fullNameTextField: UITextField = .createBorderedTextField()
    private let fullNameTitleLabel: InsetLabel = .createInsetLabel(
        font: Typography.Medium.body,
        textColor: .textColorWhiteGrey,
        text: "Full Name",
        backgroundColor: .primaryBackground
    )
    private let fullNameWarningLabel: UILabel = .createLabel(font: Typography.Medium.body, textColor: .secondaryRed)
    // Email
    private let emailTextField: UITextField = .createBorderedTextField(keyboardType: .emailAddress)
    private let emailTitleLabel: InsetLabel = .createInsetLabel(
        font: Typography.Medium.body,
        textColor: .textColorWhiteGrey,
        text: "Email",
        backgroundColor: .primaryBackground
    )
    private let emailWarningLabel: UILabel = .createLabel(font: Typography.Medium.body, textColor: .secondaryRed)
    // Save Changes
    private lazy var saveChangesButton = UIButton(
        title: "Save Changes",
        font: Typography.Medium.title,
        titleColor: .textColorWhite,
        backgroundColor: .primaryBlueAccent,
        cornerRadius: 30,
        action: #selector(didTapSaveChanges),
        target: self
    )
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
    func showUserProfile(_ profile: UserProfileViewModelProtocol) {
        profileImageView.kf.setImage(with: profile.profileImageURL, placeholder: Asset.Avatars.avatarMock.image)
        fullNameLabel.text = profile.name
        emailLabel.text = profile.email
        fullNameTextField.text = profile.name
        emailTextField.text = profile.email
        hideLoadingIndicator()
    }

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
}

// MARK: - Setup
extension EditProfileView {
    private func setupView() {
        backgroundColor = .primaryBackground
        // Header
        addSubviews(loadingIndicator)
        editBackgroundView.addSubviews(editIconImageView)
        addSubviews(profileImageView, editBackgroundView, fullNameLabel, emailLabel)
        // Body
        addSubviews(fullNameTextField, fullNameTitleLabel, fullNameWarningLabel)
        addSubviews(emailTextField, emailTitleLabel, emailWarningLabel)
        // Bottom
        addSubviews(saveChangesButton)
        // Additional subviews setup
        setAdditionalSubviewsPreferences()

        setupGestureRecognizers()
    }

    private func setAdditionalSubviewsPreferences() {
        let textInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        fullNameTitleLabel.textInsets = textInset
        emailTitleLabel.textInsets = textInset
        // Setup delegation
    }

    private func setupGestureRecognizers() {
        // Tap gesture for profileImageView
        let profileImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        profileImageView.addGestureRecognizer(profileImageViewTapGesture)
        profileImageView.isUserInteractionEnabled = true
        // Tap gesture for editBackgroundView
        let editBackgroundViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        editBackgroundView.addGestureRecognizer(editBackgroundViewTapGesture)
        editBackgroundView.isUserInteractionEnabled = true
        // Tap gesture for editIconImageView
        let editIconImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        editIconImageView.addGestureRecognizer(editIconImageViewTapGesture)
        editIconImageView.isUserInteractionEnabled = true
    }
}

// MARK: - ActionMethods
extension EditProfileView {
    @objc
    private func didTapSaveChanges() {
        delegate?.didTapSaveChanges()
    }

    @objc
    private func imageViewTapped() {
        guard let viewController = parentViewController else {
            return
        }

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        viewController.present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension EditProfileView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
//            saveAvatarToUserDefaults()
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Constraints
extension EditProfileView {
    private func setupConstraints() {
        setupHeaderConstraints()
        setupBodyConstraints()
        setupBottomConstraints()
    }

    private func setupHeaderConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.width.height.equalTo(100)
        }

        editBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.centerY).offset(16)
            make.leading.equalTo(profileImageView.snp.centerX).offset(16)
            make.width.height.equalTo(40)
        }

        editIconImageView.snp.makeConstraints { make in
            make.center.equalTo(editBackgroundView)
            make.width.height.equalTo(16)
        }

        fullNameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
        }

        emailLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(fullNameLabel.snp.bottom).offset(8)
        }
    }

    private func setupBodyConstraints() {
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        fullNameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(emailLabel.snp.bottom).offset(32)
            make.height.equalTo(60)
        }

        fullNameTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(fullNameTextField).offset(16)
            make.top.equalTo(fullNameTextField).offset(-8)
        }

        fullNameWarningLabel.snp.makeConstraints { make in
            make.leading.equalTo(fullNameTextField).offset(16)
            make.top.equalTo(fullNameTextField.snp.bottom).offset(8)
        }

        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(fullNameWarningLabel.snp.bottom).offset(24)
            make.height.equalTo(60)
        }

        emailTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(emailTextField).offset(16)
            make.top.equalTo(emailTextField).offset(-8)
        }

        emailWarningLabel.snp.makeConstraints { make in
            make.leading.equalTo(emailTextField).offset(16)
            make.top.equalTo(emailTextField.snp.bottom).offset(8)
        }
    }

    private func setupBottomConstraints() {
        saveChangesButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(60)
        }
    }
}
