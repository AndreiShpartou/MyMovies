//
//  ProfileRouter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

class ProfileRouter: ProfileRouterProtocol {
    weak var viewController: UIViewController?

    // MARK: - Init
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }

    // MARK: - ProfileRouterProtocol
    func navigateToEditProfile() {
//        let editProfileVC = SceneBuilder.buildEditProfileScene()
//        viewController?.navigationController?.pushViewController(editProfileVC, animated: true)
    }

    func navigateToSettingItem(_ item: ProfileSettingsItem) {
//        switch item {
//        case .notification:
//            let notificationVC = SceneBuilder.buildNotificationSettingsScene()
//            viewController?.navigationController?.pushViewController(notificationVC, animated: true)
//        case .language:
//            let languageVC = SceneBuilder.buildLanguageSettingsScene()
//            viewController?.navigationController?.pushViewController(languageVC, animated: true)
//        case .legalAndPolicies:
//            let legalVC = SceneBuilder.buildLegalAndPoliciesScene()
//            viewController?.navigationController?.pushViewController(legalVC, animated: true)
//        case .aboutUs:
//            let aboutUsVC = SceneBuilder.buildAboutUsScene()
//            viewController?.navigationController?.pushViewController(aboutUsVC, animated: true)
//        }
    }
}
