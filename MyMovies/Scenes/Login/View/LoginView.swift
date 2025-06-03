//
//  LoginView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import UIKit

final class LoginView: UIView, LoginViewProtocol {
    weak var delegate: LoginViewDelegate?

    private var arrayOfTextFields: [UITextField] = []
    // UITextField.tag: UILabel
    private var textFieldTagsWarningLabelsDict: [Int: UILabel] = [:]

    // MARK: - UIComponents Scroll
    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()

    // Indicators
    private let loadingIndicator: UIActivityIndicatorView = .createSpinner(style: .medium)

    // MARK: - Header
    private lazy var backButton: UIButton = .createBackNavBarButton(
        action: #selector(backButtonTapped),
        target: self,
        image: UIImage(systemName: "chevron.down")
    )

    private let welcomeImageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFit,
        clipsToBounds: true,
        image: Asset.Login.greeting.image
    )

    // MARK: - Body
    private let emailLabel: UILabel = .createLabel(
        font: Typography.Medium.subhead,
        textColor: .textColorWhite,
        text: "Email"
    )

    private let emailTextField: UITextField = .createBorderedTextField(
        placeholder: "Your Email",
        keyboardType: .emailAddress,
        cornerRadius: 15,
        accessibilityIdentifier: AccessibilityIdentifier.loginEmailTextField
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
        placeholder: "Your Password",
        cornerRadius: 15,
        accesssibilityIdentifier: AccessibilityIdentifier.loginPasswordTextField
    )

    private let passwordWarningLabel: UILabel = .createLabel(
        font: Typography.Medium.body,
        textColor: .secondaryRed,
        text: "* Passsword is empty"
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
        target: self,
        accessibilityIdentifier: AccessibilityIdentifier.loginScreenSignInButton
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
        target: self,
        accessibilityIdentifier: AccessibilityIdentifier.loginScreenSignUpButton
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
    func setLoadingIndicator(isVisible: Bool) {
        if isVisible {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }

    func showError(with message: String) {
        guard let viewController = parentViewController,
              viewController.presentedViewController == nil else {
            return
        }

        // Present an alert to the user
        let alert = getGlobalAlertController(for: message)
        viewController.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Setup
extension LoginView {
    private func setupView() {
        backgroundColor = .primaryBackground

        addSubviews(backButton)
        scrollView.addSubviews(scrollContentView)
        addSubviews(scrollView, loadingIndicator)

        setupSubviews()
    }

    private func setupSubviews() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delaysContentTouches = false

        scrollContentView.addSubviews(
            welcomeImageView,
            emailLabel,
            emailTextField,
            emailWarningLabel,
            passwordLabel,
            passwordTextField,
            passwordWarningLabel,
            alreadyHaveAccountLabel,
            signInButton,
            dontHaveAnAccountLabel,
            signUpButton
        )

        // Setup warning labels
        let warningLabels = [emailWarningLabel, passwordWarningLabel]
        warningLabels.forEach { $0.isHidden = true }
        // Setup delegation and tags
        arrayOfTextFields = [emailTextField, passwordTextField]
        arrayOfTextFields.enumerated().forEach { index, textField in
            textField.tag = index
            textField.delegate = self
            textFieldTagsWarningLabelsDict[index] = warningLabels[index]
        }
    }
}

// MARK: - ActionMethods
extension LoginView {
    @objc
    private func didTapSignInButton() {
        guard isAllDataFilled() else {
            return
        }

        delegate?.didTapSignInButton(
            email: emailTextField.text!,
            password: passwordTextField.text!
        )
    }

    @objc
    private func didTapSignUpButton() {
        delegate?.didTapSignUpButton()
    }

    @objc
    private func backButtonTapped() {
        delegate?.didTapBackButton()
    }
}

// MARK: - Helpers
extension LoginView {
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
extension LoginView: UIViewKeyboardScrollHandlingProtocol {
    func adjustScrollOffset(with offset: CGFloat) {
        scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
    }

    func adjustScrollInset(with inset: CGFloat) {
        scrollView.contentInset.bottom = inset
        setNeedsLayout()
    }
}

// MARK: - UITextFieldDelegate
extension LoginView: UITextFieldDelegate {
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
extension LoginView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIControl {
            return false
        }

        return true
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
        backButton.snp.makeConstraints { make in
            make.leading.top.equalTo(safeAreaLayoutGuide).inset(12)
            make.width.height.equalTo(30)
        }

        scrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(backButton.snp.bottom).offset(8)
        }

        scrollContentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }

        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func setupHeaderConstraints() {
        welcomeImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(32)
            make.height.equalTo(170)
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

        emailWarningLabel.snp.makeConstraints { make in
            make.leading.equalTo(emailTextField).offset(16)
            make.top.equalTo(emailTextField.snp.bottom).offset(4)
        }

        passwordLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(emailWarningLabel.snp.bottom).offset(8)
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
        alreadyHaveAccountLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(passwordWarningLabel.snp.bottom).offset(24)
        }

        signInButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(alreadyHaveAccountLabel.snp.bottom).offset(8)
            make.height.equalTo(70)
        }

        dontHaveAnAccountLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(signInButton.snp.bottom).offset(24)
        }

        signUpButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(dontHaveAnAccountLabel.snp.bottom).offset(8)
            make.height.equalTo(70)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
