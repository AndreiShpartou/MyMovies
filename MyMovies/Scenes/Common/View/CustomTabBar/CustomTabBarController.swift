//
//  CustomTabBarController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 04/08/2024.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override var selectedIndex: Int {
        didSet {
            // Update custom tab bar appearance
            customTabBar.selectItem(at: selectedIndex)
        }
    }

    private let customTabBar = CustomTabBar()
    private var previousNavigationController: UINavigationController?

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
        customTabBar.accessibilityIdentifier = AccessibilityIdentifier.tabBar

        let homeVC = SceneBuilder.buildHomeScene()
        let searchVC = SceneBuilder.buildSearchScene()
        let wishlistVC = SceneBuilder.buildWishlistScene()
        let profileVC = SceneBuilder.buildProfileScene()

        viewControllers = [homeVC, searchVC, wishlistVC, profileVC]

        setupCustomTabBarItems()
        previousNavigationController = homeVC as? UINavigationController
    }

    private func setupCustomTabBarItems() {
        // Setup custom items
        let homeItem = CustomTabBarItem(icon: UIImage(systemName: "house"), title: "Home")
        let searchItem = CustomTabBarItem(icon: UIImage(systemName: "magnifyingglass"), title: "Search")
        let wishlistItem = CustomTabBarItem(icon: UIImage(systemName: "heart"), title: "Wishlist")
        let profileItem = CustomTabBarItem(icon: UIImage(systemName: "person"), title: "Profile")
        profileItem.accessibilityIdentifier = AccessibilityIdentifier.profileItem

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

        // Switch the system tab bar's selection
        selectedIndex = tappedItem.tag
        // Send notifications
        tabBarControllerDidSelect()
    }
}

// MARK: - Notifications
extension CustomTabBarController {
    private func tabBarControllerDidSelect() {
        guard let currentNavigationController = viewControllers?[selectedIndex] as? UINavigationController else {
            return
        }

        guard previousNavigationController == currentNavigationController else {
            previousNavigationController = currentNavigationController
            return
        }

        if let currentViewController = currentNavigationController.topViewController,
           currentViewController == currentNavigationController.viewControllers.first {
            NotificationCenter.default.post(
                name: .activeTabBarItemRootVCTapped,
                object: nil
            )
        } else {
            currentNavigationController.popToRootViewController(animated: true)
        }
    }
}
