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
        // E.g., present your main tab bar or root scene
        let mainTabBar = RootRouter.createRootViewController()
        mainTabBar.modalPresentationStyle = .fullScreen
        viewController?.present(mainTabBar, animated: true)
    }
}
