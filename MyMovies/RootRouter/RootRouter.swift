//
//  RootRouter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 28/07/2024.
//

import UIKit

protocol RootRouterProtocol: AnyObject {
    static func start(in windows: UIWindow)
    static func switchToMainFlow(in window: UIWindow?)
}

// Attaches the initial root UIViewController to the window,
// Deciding whether to show Onboarding or the main tab bar.
// Preloading movies and genres in the background optionally
final class RootRouter: RootRouterProtocol {
    // Retain the interactor to prevent deallocation
    private static var prefetchInteractor: PrefetchInteractorProtocol?

    static func start(in window: UIWindow) {
        // Configure common App settings & API settings depending on user location
        AppConfigurationManager.shared.configure(
            networkHelper: NetworkHelper.shared,
            plistLoader: PlistConfigurationLoader()
        )
        AppConfigurationManager.shared.setupMainConfiguration()
        AppConfigurationManager.shared.setupCacheConfiguration()

        // Check if user has seen onboarding
        let hasSeenOnboardingKey = "hasSeenOnboarding"
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: hasSeenOnboardingKey)

        // Decide which initial view controller to show
        if hasSeenOnboarding {
            // User has completed onboarding previously -> show main flow
            switchToMainFlow(in: window)
        } else {
            // User has NOT seen onboarding -> show onboarding flow
            window.rootViewController = SceneBuilder.buildOnboardingScene()
            // Start fetching data in the background
            backgroundPrefetchData()

            window.makeKeyAndVisible()
        }
    }

    static func switchToMainFlow(in window: UIWindow?) {
        guard let window = window else { return }
        // Release the interactor
        prefetchInteractor = nil

        let mainTabBar = createMainTabBar()
        window.rootViewController = mainTabBar

        window.makeKeyAndVisible()
    }

    // Creates & returns the CustomTabBarController
    private static func createMainTabBar() -> UITabBarController {
        return CustomTabBarController()
    }

    // Background data prefetching.
    private static func backgroundPrefetchData() {
        prefetchInteractor = MainInteractor()
        DispatchQueue.global(qos: .background).async {
            prefetchInteractor?.prefetchData()
        }
    }
}
