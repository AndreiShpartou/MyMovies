//
//  LoginRouter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import UIKit

final class LoginRouter: LoginRouterProtocol {
    weak var viewController: UIViewController?

    init() {}

    // MARK: - Public
    func navigateToSignUp() {
    }

    func navigateToMainFlow() {
        let window = viewController?.view.window
        // Switch to main flow
        RootRouter.switchToMainFlow(in: window)
    }
}
