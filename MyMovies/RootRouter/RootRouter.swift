//
//  RootRouter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 28/07/2024.
//

import UIKit

final class RootRouter {
    static func createRootViewController() -> UITabBarController {
        let tabBarController = UITabBarController()
        let homeVC = SceneBuilder.buildHomeModule()
        
        tabBarController.viewControllers = [homeVC]
        
        return tabBarController
    }
}
