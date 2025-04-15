//
//  MockLoginRouter.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 15/04/2025.
//

import UIKit
@testable import MyMovies

final class MockLoginRouter: LoginRouterProtocol {
    weak var viewController: UIViewController?
    
    var didCallNavigateToSignUp: Bool = false
    var didCallNavigateToMainFlow: Bool = false
    var didCallDismissScene: Bool = false
    
    // MARK: - Init
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    // MARK: - LoginRouterProtocol
    func navigateToSignUp() {
        didCallNavigateToSignUp = true
    }
    
    func navigateToMainFlow() {
        didCallNavigateToMainFlow = true
    }
    
    func dismissScene() {
        didCallDismissScene = true
    }
}
