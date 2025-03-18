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
}

// MARK: - Private Setup
extension CustomTabBarController {
    private func setupController() {
        // Replace the system tabBar with the custom one
        setValue(customTabBar, forKey: "tabBar")

        let homeVC = SceneBuilder.buildHomeScene()
        let searchVC = SceneBuilder.buildSearchScene()
        let wishlistVC = SceneBuilder.buildWishlistScene()
        let profileVC = SceneBuilder.buildProfileScene()

        viewControllers = [homeVC, searchVC, wishlistVC, profileVC]

        setupCustomTabBarItems()
    }

    private func setupCustomTabBarItems() {
        // Setup custom items
        let homeItem = CustomTabBarItem(icon: UIImage(systemName: "house"), title: "Home")
        let searchItem = CustomTabBarItem(icon: UIImage(systemName: "magnifyingglass"), title: "Search")
        let wishlistItem = CustomTabBarItem(icon: UIImage(systemName: "heart"), title: "Wishlist")
        let profileItem = CustomTabBarItem(icon: UIImage(systemName: "person"), title: "Profile")

        let items = [homeItem, searchItem, wishlistItem, profileItem]
        for (index, item) in items.enumerated() {
            item.tag = index
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tabBarItemTapped(_:)))
            item.addGestureRecognizer(tapGesture)
        }

        customTabBar.setCustomItems(items)
        customTabBar.selectItem(at: 0) // default selection
    }
}

// MARK: - ActionMethods
extension CustomTabBarController {
    @objc
    private func tabBarItemTapped(_ gesture: UITapGestureRecognizer) {
        guard let tappedItem = gesture.view as? CustomTabBarItem else { return }

        let index = tappedItem.tag
        // Switch the system tab bar's selection
        selectedIndex = index
        // Update custom tab bar appearance
        self.customTabBar.selectItem(at: index)
    }
}
