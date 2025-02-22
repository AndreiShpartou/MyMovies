//
//  OnboardingRouterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 20/02/2025.
//

import Foundation

protocol OnboardingRouterProtocol: AnyObject {
    var viewController: OnboardingViewController? { get set }

    func navigateToMainFlow()
}
