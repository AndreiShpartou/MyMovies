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

    private var arrayOfTextFields: [UITextField] = []
    // UITextField.tag: UILabel
    private var textFieldTagsWarningLabelsDict: [Int: UILabel] = [:]
    private var isProfileImageChanged = false

    // MARK: - UIComponents
    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()

    // Indicators
    private let loadingIndicator: UIActivityIndicatorView = .createSpinner(style: .medium)

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
    private let fullNameTextField: UITextField = .createBorderedTextField(keyboardType: .namePhonePad)
    private let fullNameTitleLabel: InsetLabel = .createInsetLabel(
        font: Typography.Medium.body,
        textColor: .textColorWhiteGrey,
        text: "Full Name",
        backgroundColor: .primaryBackground
    )
    private let fullNameWarningLabel: UILabel = .createLabel(
        font: Typography.Medium.body,
        textColor: .secondaryRed,
        text: "* Name is empty"
    )
    // Email
    private let emailTextField: UITextField = .createBorderedTextField(keyboardType: .emailAddress)
    private let emailTitleLabel: InsetLabel = .createInsetLabel(
        font: Typography.Medium.body,
        textColor: .textColorWhiteGrey,
        text: "Email",
        backgroundColor: .primaryBackground
    )
    private let emailWarningLabel: UILabel = .createLabel(
        font: Typography.Medium.body,
        textColor: .secondaryRed,
        text: "* Email is empty"
    )
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

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initHideKeyboard(with: self)

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func showUserProfile(_ profile: UserProfileViewModelProtocol) {
        profileImageView.kf.setImage(with: profile.profileImageURL, placeholder: Asset.Avatars.signedUser.image)
        fullNameLabel.text = profile.name
        emailLabel.text = profile.email
        fullNameTextField.text = profile.name
        emailTextField.text = profile.email
    }

    func setLoadingIndicator(isVisible: Bool) {
        if isVisible {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }

    func showError(_ message: String) {
        guard let viewController = parentViewController else {
            return
        }

        // Present an alert to the user
        let alert = getGlobalAlertController(for: message)
        viewController.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Setup
extension EditProfileView {
    private func setupView() {
        backgroundColor = .primaryBackground

        scrollView.addSubviews(scrollContentView)
        addSubviews(scrollView, loadingIndicator)
        // Header
        editBackgroundView.addSubviews(editIconImageView)
        scrollContentView.addSubviews(profileImageView, editBackgroundView, fullNameLabel, emailLabel)
        // Body
        scrollContentView.addSubviews(fullNameTextField, fullNameTitleLabel, fullNameWarningLabel)
        scrollContentView.addSubviews(emailTextField, emailTitleLabel, emailWarningLabel)
        // Bottom
        scrollContentView.addSubviews(saveChangesButton)
        // Additional subviews setup
        setAdditionalSubviewsPreferences()

        setupGestureRecognizers()
    }

    private func setAdditionalSubviewsPreferences() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delaysContentTouches = false
        emailTextField.isEnabled = false

        // Setup label insets
        let textInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        fullNameTitleLabel.textInsets = textInset
        emailTitleLabel.textInsets = textInset
        // Setup warning labels
        let warningLabels = [fullNameWarningLabel, emailWarningLabel]
        warningLabels.forEach { $0.isHidden = true }
        // Setup delegation and tags
        // arrayOfTextFields = [fullNameTextField, emailTextField] // Temporary disable email editing
        arrayOfTextFields = [fullNameTextField]
        arrayOfTextFields.enumerated().forEach { index, textField in
            textField.tag = index
            textField.delegate = self
            textFieldTagsWarningLabelsDict[index] = warningLabels[index]
        }
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
        guard isAllDataFilled() else {
            return
        }

        let userProfileImage = isProfileImageChanged ? profileImageView.image : nil
        delegate?.didTapSaveChanges(name: fullNameTextField.text!, profileImage: userProfileImage)
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

// MARK: - Helpers
extension EditProfileView {
    private func isAllDataFilled() -> Bool {
        var isDataFilled = true

        arrayOfTextFields.forEach {
            if ($0.text ?? "").isEmpty {
                $0.layer.borderColor = UIColor.secondaryRed.cgColor
                textFieldTagsWarningLabelsDict[$0.tag]?.isHidden = false
                isDataFilled = false
            }
        }

        return isDataFilled
    }
}

// MARK: - UIViewKeyboardScrollHandlingProtocol
extension EditProfileView: UIViewKeyboardScrollHandlingProtocol {
    func adjustScrollOffset(with offset: CGFloat) {
        scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
    }

    func adjustScrollInset(with inset: CGFloat) {
        scrollView.contentInset.bottom = inset
    }
}

// MARK: - UIImagePickerControllerDelegate
extension EditProfileView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
            isProfileImageChanged = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension EditProfileView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .textColorWhite
        textField.layer.borderColor = UIColor.selectedBorder.cgColor
        // Update warnings
        textFieldTagsWarningLabelsDict[textField.tag]?.isHidden = true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.textColor = .textColorGrey

        if let text = textField.text,
            text.isEmpty {
            textFieldTagsWarningLabelsDict[textField.tag]?.isHidden = false
            textField.layer.borderColor = UIColor.secondaryRed.cgColor
        } else {
            textFieldTagsWarningLabelsDict[textField.tag]?.isHidden = true
            textField.layer.borderColor = UIColor.unselectedBorder.cgColor
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension EditProfileView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIControl {
            return false
        }

        return true
    }
}

// MARK: - Constraints
extension EditProfileView {
    private func setupConstraints() {
        setupScrollConstraints()
        setupHeaderConstraints()
        setupBodyConstraints()
        setupBottomConstraints()
    }

    private func setupScrollConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        scrollContentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }

        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func setupHeaderConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
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
            make.top.equalTo(emailWarningLabel.snp.bottom).offset(32)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
