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
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }

    // MARK: - ProfileRouterProtocol
    func navigateToEditProfile() {
        let editProfileVC = SceneBuilder.buildEditProfileScene()
        editProfileVC.title = "Edit Profile"
        viewController?.navigationController?.pushViewController(editProfileVC, animated: true)
    }

    func navigateToGeneralTextInfoScene(labelText: String?, textViewText: String?, title: String?) {
        let generaTextInfolVC = SceneBuilder.buildGeneralTextInfoScene(labelText: labelText, textViewText: textViewText, title: title)
        generaTextInfolVC.title = title
        viewController?.navigationController?.pushViewController(generaTextInfolVC, animated: true)
    }
}
