//
//  EditProfileViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 13/10/2024.
//

import UIKit

protocol EditProfileViewControllerProtocol {
    var presenter: EditProfilePresenterProtocol { get set }
}

class EditProfileViewController: UIViewController, EditProfileViewControllerProtocol {
    var presenter: EditProfilePresenterProtocol

    private let editProfileView: EditProfileViewProtocol

    // MARK: - Init
    init(editProfileView: EditProfileViewProtocol, presenter: EditProfilePresenterProtocol) {
        self.presenter = presenter
        self.editProfileView = editProfileView

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func loadView() {
        view = editProfileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
        presenter.viewDidLoad()
    }
}

// MARK: - Setup
extension EditProfileViewController {
    private func setupViewController() {
        setupNavigationController()
    }

    private func setupNavigationController() {
        navigationController?.navigationBar.titleTextAttributes = getNavigationBarTitleAttributes()
        navigationItem.leftBarButtonItem = .createCustomBackBarButtonItem(action: #selector(backButtonTapped), target: self)
    }
}

// MARK: - ActionMethods
extension EditProfileViewController {
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
