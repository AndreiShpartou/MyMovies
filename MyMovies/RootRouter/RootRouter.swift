//
//  RootRouter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 28/07/2024.
//

import UIKit

protocol RootRouterProtocol: AnyObject {
    static func createRootViewController() -> UITabBarController
}

final class RootRouter: RootRouterProtocol {
    static func createRootViewController() -> UITabBarController {
        let tabBarController = UITabBarController()
        let homeVC = SceneBuilder.buildHomeScene()
        let searchVC = SceneBuilder.buildSearchScene()
        let profileVC = SceneBuilder.buildProfileScene()

        tabBarController.viewControllers = [homeVC, searchVC, profileVC]

        return tabBarController
    }
}
