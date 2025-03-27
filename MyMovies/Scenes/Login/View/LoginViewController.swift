//
//  LoginViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import UIKit

protocol LoginViewControllerProtocol: UIViewController {
    var presenter: LoginPresenterProtocol { get set }
}

final class LoginViewController: UIViewController {
    var presenter: LoginPresenterProtocol
    private let loginView: LoginViewProtocol

    // MARK: - Init
    init(loginView: LoginViewProtocol, presenter: LoginPresenterProtocol) {
        self.presenter = presenter
        self.loginView = loginView

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = true

        // Setup notification observers
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Remove notification observers
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

// MARK: - Setup
extension LoginViewController {
    private func setupViewController() {
        loginView.delegate = self
    }
}

// MARK: - ActionMethods
extension LoginViewController {
    @objc
    private func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        // Calculating y position where keyboard overlap view
        guard let textField = view.selectedTextField else {
            return
        }
        // Convert from Subviews coordinates to View coordinates
        let textFieldOrigin = view.convert(textField.frame.origin, from: textField.superview)
        let positionYForChecking = textFieldOrigin.y + textField.frame.height + Sizes.Small.padding
        // Convert from UIWindows coordinates to View coordinates
        let keyboardOrigin = view.convert(keyboardSize.origin, from: view.window)

        loginView.adjustScrollInset(with: keyboardSize.height)

        if positionYForChecking > keyboardOrigin.y {
            loginView.adjustScrollOffset(with: keyboardSize.height)
        }
    }

    @objc
    private func keyboardWillHide(notification: Notification) {
        loginView.adjustScrollInset(with: 0)
    }
}

// MARK: - LoginViewDelegate
extension LoginViewController: LoginViewDelegate {
    func didTapLoginButton() {
    }

    func didTapSignUpButton() {
        presenter.didTapSignUpButton()
    }

    func didTapBackButton() {
        presenter.didTapBackButton()
    }
}
