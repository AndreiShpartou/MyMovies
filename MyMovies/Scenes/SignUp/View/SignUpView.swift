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

    private lazy var fulllNameTextField: UITextField = .createBorderedTextField(
        action: #selector(fullNameEditingChanged),
        target: self,
        placeholder: "Full Name",
        keyboardType: .namePhonePad,
        cornerRadius: 15
    )

    private let emailLabel: UILabel = .createLabel(
        font: Typography.Medium.subhead,
        textColor: .textColorWhite,
        text: "Email"
    )

    private lazy var emailTextField: UITextField = .createBorderedTextField(
        action: #selector(emailEditingChanged),
        target: self,
        placeholder: "Example@mail.com",
        keyboardType: .emailAddress,
        cornerRadius: 15
    )

    private let passwordLabel: UILabel = .createLabel(
        font: Typography.Medium.subhead,
        textColor: .textColorWhite,
        text: "Password"
    )

    private lazy var passwordTextField: UITextField = UIPasswordTextField(
        action: #selector(passwordEditingChanged),
        target: self,
        placeholder: "At Least 8 Characters",
        cornerRadius: 15
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
            emailLabel,
            emailTextField,
            passwordLabel,
            passwordTextField,
            signUpButton
        )
    }

    private func updateDelegates() {
        emailTextField.delegate = delegate
        passwordTextField.delegate = delegate
    }
}

// MARK: - ActionMethods
extension SignUpView {
    @objc
    private func fullNameEditingChanged() {
    }

    @objc
    private func emailEditingChanged() {
    }

    @objc
    private func passwordEditingChanged() {
    }

    @objc
    private func didTapSignUpButton() {
    }

    @objc
    private func viewWasTapped() {
        endEditing(true)
    }
}

// MARK: - Constraits
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

        emailLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(fulllNameTextField.snp.bottom).offset(16)
        }

        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.height.equalTo(45)
        }

        passwordLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
        }

        passwordTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
            make.height.equalTo(45)
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
