//
//  CustomTabBarController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 04/08/2024.
//

import UIKit

class CustomTabBarController: UITabBarController {
    private let customTabBar = CustomTabBar()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupController()
    }

    // MARK: - Setup
    private func setupController() {
        setValue(customTabBar, forKey: "tabBar")

        let homeVC = SceneBuilder.buildHomeScene()
        let searchVC = SceneBuilder.buildSearchScene()
        let profileVC = SceneBuilder.buildProfileScene()

        viewControllers = [homeVC, searchVC, profileVC]

        setupCustomTabBarItems()
    }

    private func setupCustomTabBarItems() {
        let homeItem = CustomTabBarItem(icon: UIImage(systemName: "house"), title: "Home")
        let searchItem = CustomTabBarItem(icon: UIImage(systemName: "magnifyingglass"), title: "Search")
        let profileItem = CustomTabBarItem(icon: UIImage(systemName: "person"), title: "Profile")

        customTabBar.setCustomItems([homeItem, searchItem, profileItem])
        customTabBar.selectItem(at: 0)

        homeItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabBarItemTapped)))
        searchItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabBarItemTapped)))
        profileItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabBarItemTapped)))
    }

    @objc
    private func tabBarItemTapped(_ gesture: UITapGestureRecognizer) {
            guard let tappedItem = gesture.view as? CustomTabBarItem,
              let index = customTabBar.customTabBarItems.firstIndex(of: tappedItem) else {
            return
        }

        selectedIndex = index
        customTabBar.selectItem(at: index)
    }
}
