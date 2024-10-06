//
//  ProfileViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

class ProfileViewController: UIViewController {
    var presenter: ProfileSettingsPresenterProtocol?

    private let profileView: UIView

    // MARK: - Init
    init(profileView: UIView) {
        self.profileView = profileView

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func loadView() {
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
    }
}

// MARK: - Setup
extension ProfileViewController {
    private func setupViewController() {
    }
}
