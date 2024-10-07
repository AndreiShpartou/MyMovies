//
//  ProfileViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    var presenter: ProfileSettingsPresenterProtocol?

    private let profileSettingsView: ProfileSettingsViewProtocol

    // MARK: - Init
    init(profileSettingsView: ProfileSettingsViewProtocol) {
        self.profileSettingsView = profileSettingsView

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
        presenter?.viewDidLoad()
    }
}

// MARK: - Setup
extension ProfileViewController {
    private func setupViewController() {
        profileSettingsView.delegate = self
    }

    private func setupNavigationBar() {
        title = NSLocalizedString("ProfileSettings", comment: "Profile")
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension ProfileViewController: ProfileSettingsInteractionDelegate {
    func didTapEditProfile() {
        //
    }
}
