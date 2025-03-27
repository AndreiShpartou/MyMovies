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
    }
}

// MARK: - Setup
extension LoginViewController {
    private func setupViewController() {
        loginView.delegate = self
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
