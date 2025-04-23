//
//  ProfileSettingsViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

protocol ProfileSettingsViewControllerProtocol {
    var presenter: ProfileSettingsPresenterProtocol { get set }
}

final class ProfileSettingsViewController: UIViewController {
    var presenter: ProfileSettingsPresenterProtocol

    private let profileSettingsView: ProfileSettingsViewProtocol

    // MARK: - Init
    init(profileSettingsView: ProfileSettingsViewProtocol, presenter: ProfileSettingsPresenterProtocol) {
        self.profileSettingsView = profileSettingsView
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func loadView() {
        view = profileSettingsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationBar()
    }
}

// MARK: - Setup
extension ProfileSettingsViewController {
    private func setupViewController() {
        profileSettingsView.delegate = self
    }

    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        navigationItem.title = NSLocalizedString("Profile", comment: "Profile settings")
        navigationController?.navigationBar.titleTextAttributes = getNavigationBarTitleAttributes()
        tabBarController?.title = nil
    }
}

// MARK: - ProfileSettingsInteractionDelegate
extension ProfileSettingsViewController: ProfileSettingsInteractionDelegate {
    func didTapSignIn() {
        presenter.navigateToSignIn()
    }

    func didTapEditProfile() {
        presenter.navigateToEditProfile()
    }

    func didSelectSetting(at indexPath: IndexPath) {
        presenter.didSelectSetting(at: indexPath)
    }

    func didTapSignOut() {
        presenter.signOut()
    }
}
