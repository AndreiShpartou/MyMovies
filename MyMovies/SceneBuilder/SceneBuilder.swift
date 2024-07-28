//
//  SceneBuilder.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 28/07/2024.
//

import UIKit

final class SceneBuilder {
    static func buildHomeScene() -> UIViewController {
        let view = MainView()
        let viewController = MainViewController(mainView: view)
        let router = MainRouter(viewController: viewController)
        let interactor = MainInteractor()
        let presenter = MainPresenter(view: viewController, interactor: interactor, router: router)
        
        view.presenter = presenter
        viewController.presenter = presenter
        interactor.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            tag: 0
        )

        return navigationController
    }
    
    static func buildSearchScene() -> UIViewController {
        let view = SearchView()
        let viewController = SearchViewController(searchView: view)
        let router = SearchRouter(viewController: viewController)
        let interactor = SearchInteractor()
        let presenter = SearchPresenter(view: viewController, interactor: interactor, router: router)
        
        view.presenter = presenter
        viewController.presenter = presenter
        interactor.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            tag: 1
        )
        
        return navigationController
    }
    
    static func buildProfileScene() -> UIViewController {
        return UIViewController()
    }
}
