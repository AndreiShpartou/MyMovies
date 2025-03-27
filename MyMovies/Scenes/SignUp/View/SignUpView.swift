//
//  SignUpView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import UIKit

final class SignUpView: UIView, SignUpViewProtocol {
    weak var delegate: SignUpViewDelegate?

    private var arrayOfTextFields: [UITextField] = []
    // UITextField.tag: UILabel
    private var textFieldTagsWarningLabelsDict: [Int: UILabel] = [:]

    // MARK: - UIComponents Scroll
    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
    // MARK: - Header
    private let signUpLabel: UILabel = .createLabel(
        font: Typography.SemiBold.largeTitle,
        textColor: .textColorWhite,
        text: "Sign Up"
    )

    private let enterDetailsLabel: UILabel = .createLabel(
        font: Typography.Medium.title,
        textColor: .textColorWhiteGrey,
        text: "Please Enter Your Details"
    )

    // MARK: - Body
    private let fullNameLabel: UILabel = .createLabel(
        font: Typography.Medium.subhead,
        textColor: .textColorWhite,
        text: "Full Name"
    )

    private let fulllNameTextField: UITextField = .createBorderedTextField(
        placeholder: "Full Name",
        keyboardType: .namePhonePad,
        cornerRadius: 15
    )

    private let fullNameWarningLabel: UILabel = .createLabel(
        font: Typography.Medium.body,
        textColor: .secondaryRed,
        text: "* Full Name is empty"
    )

    private let emailLabel: UILabel = .createLabel(
        font: Typography.Medium.subhead,
        textColor: .textColorWhite,
        text: "Email"
    )

    private let emailTextField: UITextField = .createBorderedTextField(
        placeholder: "Example@mail.com",
        keyboardType: .emailAddress,
        cornerRadius: 15
    )

    private let emailWarningLabel: UILabel = .createLabel(
        font: Typography.Medium.body,
        textColor: .secondaryRed,
        text: "* Email is empty"
    )

    private let passwordLabel: UILabel = .createLabel(
        font: Typography.Medium.subhead,
        textColor: .textColorWhite,
        text: "Password"
    )

    private let passwordTextField: UITextField = UIPasswordTextField(
        placeholder: "At Least 8 Characters",
        cornerRadius: 15
    )

    private let passwordWarningLabel: UILabel = .createLabel(
        font: Typography.Medium.body,
        textColor: .secondaryRed,
        text: "* Passsword is empty"
    )

    // MARK: - Footer
    private lazy var signUpButton = UIButton(
        title: "Sign Up",
        font: Typography.SemiBold.title,
        titleColor: .textColorWhite,
        backgroundColor: .tintColor,
        cornerRadius: Sizes.Medium.cornerRadius,
        action: #selector(didTapSignUpButton),
        target: self
    )

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
        backgroundColor = .primaryBackground

        scrollView.addSubviews(scrollContentView)
        addSubviews(scrollView)

        setupHandlers()
        setupSubviews()
    }

    private func setupHandlers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped))
        addGestureRecognizer(tapGestureRecognizer)
    }

    private func setupSubviews() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delaysContentTouches = false

        scrollContentView.addSubviews(
            signUpLabel,
            enterDetailsLabel,
            fullNameLabel,
            fulllNameTextField,
            fullNameWarningLabel,
            emailLabel,
            emailTextField,
            emailWarningLabel,
            passwordLabel,
            passwordTextField,
            passwordWarningLabel,
            signUpButton
        )

        // Setup warning labels
        let warningLabels = [fullNameWarningLabel, emailWarningLabel, passwordWarningLabel]
        warningLabels.forEach { $0.isHidden = true }
        // Setup delegation and tags
        arrayOfTextFields = [fulllNameTextField, emailTextField, passwordTextField]
        arrayOfTextFields.enumerated().forEach { index, textField in
            textField.tag = index
            textField.delegate = self
            textFieldTagsWarningLabelsDict[index] = warningLabels[index]
        }
    }
}

// MARK: - ActionMethods
extension SignUpView {
    @objc
    private func didTapSignUpButton() {
        guard isAllDataFilled() else {
            return
        }
    }

    @objc
    private func viewWasTapped() {
        endEditing(true)
    }
}

// MARK: - Helpers
extension SignUpView {
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

// MARK: - UITextFieldDelegate
extension SignUpView: UITextFieldDelegate {
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

// MARK: - Constraints
extension SignUpView {
    private func setupConstraints() {
        setupScrollViewConstraints()
        setupHeaderConstraints()
        setupBodyConstraints()
        setupFooterConstraints()
    }

    private func setupScrollViewConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        scrollContentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
    }

    private func setupHeaderConstraints() {
        signUpLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalToSuperview().inset(32)
        }

        enterDetailsLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(signUpLabel.snp.bottom).offset(8)
        }
    }

    private func setupBodyConstraints() {
        fullNameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(enterDetailsLabel.snp.bottom).offset(32)
        }

        fulllNameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(fullNameLabel.snp.bottom).offset(8)
            make.height.equalTo(45)
        }

        fullNameWarningLabel.snp.makeConstraints { make in
            make.leading.equalTo(fulllNameTextField).offset(16)
            make.top.equalTo(fulllNameTextField.snp.bottom).offset(4)
        }

        emailLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(fullNameWarningLabel.snp.bottom).offset(8)
        }

        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.height.equalTo(45)
        }

        emailWarningLabel.snp.makeConstraints { make in
            make.leading.equalTo(emailTextField).offset(16)
            make.top.equalTo(emailTextField.snp.bottom).offset(4)
        }

        passwordLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(emailWarningLabel.snp.bottom).offset(16)
        }

        passwordTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
            make.height.equalTo(45)
        }

        passwordWarningLabel.snp.makeConstraints { make in
            make.leading.equalTo(passwordTextField).offset(16)
            make.top.equalTo(passwordTextField.snp.bottom).offset(4)
        }
    }

    private func setupFooterConstraints() {
        signUpButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(passwordTextField.snp.bottom).offset(32)
            make.height.equalTo(70)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
