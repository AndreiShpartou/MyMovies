//
//  LoginView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import UIKit

final class LoginView: UIView, LoginViewProtocol {
    weak var delegate: LoginViewDelegate? {
        didSet {
            updateDelegates()
        }
    }

    // MARK: - UIComponents Scroll
    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
    // MARK: - Header
    private let welcomeImageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFit,
        clipsToBounds: true,
        image: Asset.Login.greeting.image
    )

    // MARK: - Body
    private let emailLabel: UILabel = .createLabel(
        font: Typography.Medium.body,
        textColor: .textColorWhite,
        text: "Email"
    )

    private lazy var emailTextField: UITextField = .createBorderedTextField(
        action: #selector(emailEditingChanged),
        target: self,
        placeholder: "Your Email",
        keyboardType: .emailAddress,
        cornerRadius: 15
    )

    private let passwordLabel: UILabel = .createLabel(
        font: Typography.Medium.body,
        textColor: .textColorWhite,
        text: "Password"
    )

    private lazy var passwordTextField: UITextField = UIPasswordTextField(
        action: #selector(passwordEditingChanged),
        target: self,
        placeholder: "Your Password",
        cornerRadius: 15
    )

    // MARK: - Footer
    private let alreadyHaveAccountLabel: UILabel = .createLabel(
        font: Typography.Medium.body,
        textAlignment: .center,
        textColor: .textColorGrey,
        text: "Already Have An Account?"
    )

    private lazy var signInButton = UIButton(
        title: "Sign In",
        font: Typography.SemiBold.title,
        titleColor: .textColorWhite,
        backgroundColor: .secondaryGreen,
        cornerRadius: Sizes.Medium.cornerRadius,
        action: #selector(didTapSignInButton),
        target: self
    )

    private let dontHaveAnAccountLabel: UILabel = .createLabel(
        font: Typography.Medium.body,
        textAlignment: .center,
        textColor: .textColorGrey,
        text: "Don't have an account? Sign Up"
    )

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
extension LoginView {
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
            welcomeImageView,
            emailLabel,
            emailTextField,
            passwordLabel,
            passwordTextField,
            alreadyHaveAccountLabel,
            signInButton,
            dontHaveAnAccountLabel,
            signUpButton
        )
    }

    private func updateDelegates() {
        emailTextField.delegate = delegate
        passwordTextField.delegate = delegate
    }
}

// MARK: - ActionMethods
extension LoginView {
    @objc
    private func emailEditingChanged() {
    }

    @objc
    private func passwordEditingChanged() {
    }

    @objc
    private func didTapSignInButton() {
    }

    @objc
    private func didTapSignUpButton() {
    }

    @objc
    private func viewWasTapped() {
        endEditing(true)
    }
}

// MARK: - Constraints
extension LoginView {
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
        welcomeImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(32)
            make.height.equalTo(180)
        }
    }

    private func setupBodyConstraints() {
        emailLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(welcomeImageView.snp.bottom).offset(32)
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
        alreadyHaveAccountLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(passwordTextField.snp.bottom).offset(32)
        }

        signInButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(alreadyHaveAccountLabel.snp.bottom).offset(8)
            make.height.equalTo(70)
        }

        dontHaveAnAccountLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(signInButton.snp.bottom).offset(32)
        }

        signUpButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(dontHaveAnAccountLabel.snp.bottom).offset(8)
            make.height.equalTo(70)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
