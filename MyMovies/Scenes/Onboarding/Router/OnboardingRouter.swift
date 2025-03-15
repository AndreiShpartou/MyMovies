//
//  OnboardingRouter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 20/02/2025.
//

import Foundation

final class OnboardingRouter: OnboardingRouterProtocol {
    weak var viewController: OnboardingViewController?

    func navigateToMainFlow() {
        let window = viewController?.view.window
        // Switch to main flow
        RootRouter.switchToMainFlow(in: window)
    }
}
