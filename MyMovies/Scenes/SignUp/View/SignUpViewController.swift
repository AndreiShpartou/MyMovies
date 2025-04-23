//
//  SignUpViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import UIKit

protocol SignUpViewControllerProtocol: UIViewController {
    var presenter: SignUpPresenterProtocol { get set }
}

final class SignUpViewController: UIViewController, SignUpViewControllerProtocol {
    var presenter: SignUpPresenterProtocol
    private let signUpView: SignUpViewProtocol

    // MARK: - Init
    init(signUpView: SignUpViewProtocol, presenter: SignUpPresenterProtocol) {
        self.signUpView = signUpView
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func loadView() {
        view = signUpView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationBar()

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
extension SignUpViewController {
    func setupViewController() {
        signUpView.delegate = self
    }

    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        // Setting the custom title font
        navigationController?.navigationBar.titleTextAttributes = getNavigationBarTitleAttributes()
        // Custom left button
        navigationItem.leftBarButtonItem = .createCustomBackBarButtonItem(action: #selector(backButtonTapped), target: self)
    }
}

// MARK: - ActionMethods
extension SignUpViewController {
    @objc
    private func backButtonTapped(_ sender: UIButton) {
        // Handle back button action
        navigationController?.popViewController(animated: true)
    }

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

        signUpView.adjustScrollInset(with: keyboardSize.height)

        if positionYForChecking > keyboardOrigin.y {
            signUpView.adjustScrollOffset(with: keyboardSize.height)
        }
    }

    @objc
    private func keyboardWillHide(notification: Notification) {
        signUpView.adjustScrollInset(with: 0)
    }
}

// MARK: - SignUpViewDelegate
extension SignUpViewController: SignUpViewDelegate {
    func didTapSignUpButton(email: String, password: String, fullName: String) {
        presenter.didTapSignUpButton(email: email, password: password, fullName: fullName)
    }
}
