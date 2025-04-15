//
//  LoginRouter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import UIKit

final class LoginRouter: LoginRouterProtocol {
    weak var viewController: UIViewController?

    // MARK: - Init
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }

    // MARK: - Public
    func navigateToSignUp() {
        let signUpVC = SceneBuilder.buildSignUpScene()
        viewController?.navigationController?.pushViewController(signUpVC, animated: true)
    }

    func dismissScene() {
        viewController?.dismiss(animated: true)
    }
}
