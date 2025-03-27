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
        setupNavigationBar()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = false
    }
}

// MARK: - Setup
extension SignUpViewController {
    func setupViewController() {
        signUpView.delegate = self
    }

    private func setupNavigationBar() {
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
}

// MARK: - SignUpViewDelegate
extension SignUpViewController: SignUpViewDelegate {
    func didTapSignUpButton() {
        presenter.didTapSignUpButton()
    }
}
