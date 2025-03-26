//
//  SignUpRouter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import UIKit

final class SignUpRouter: SignUpRouterProtocol {
    weak var viewController: UIViewController?

    // MARK: - Init
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }

    // MARK: - Public
    func navigateToMainFlow() {
        let window = viewController?.view.window
        // Switch to main flow
        RootRouter.switchToMainFlow(in: window)
    }
}
