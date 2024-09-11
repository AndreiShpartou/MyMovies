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
        return CustomTabBarController()
    }
}
