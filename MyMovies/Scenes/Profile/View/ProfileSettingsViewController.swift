//
//  ProfileSettingsViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

final class ProfileSettingsViewController: UIViewController {
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
extension ProfileSettingsViewController {
    private func setupViewController() {
        profileSettingsView.delegate = self
        navigationItem.title = NSLocalizedString("Profile", comment: "Profile settings")
        tabBarController?.title = nil
    }
}

extension ProfileSettingsViewController: ProfileSettingsInteractionDelegate {
    func didTapEditProfile() {
        //
    }

    func didSelectSettingsItem(_ item: ProfileSettingsItemViewModelProtocol) {
        //
    }
}
