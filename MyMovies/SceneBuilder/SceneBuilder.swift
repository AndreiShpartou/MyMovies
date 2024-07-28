//
//  SceneBuilder.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 28/07/2024.
//

import UIKit

final class SceneBuilder {
    static func buildHomeModule() -> UIViewController {
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
}
