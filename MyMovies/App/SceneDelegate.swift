//
//  SceneDelegate.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let hasSeenOnboardingKey = "hasSeenOnboarding"

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        // Configure common App settings & API settings depending on user location
        AppConfigurationManager.shared.configure(networkHelper: NetworkHelper.shared, plistLoader: PlistConfigurationLoader())
        AppConfigurationManager.shared.setupConfiguration()

        // Check UserDefaults to see if the user has seen onboarding
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: hasSeenOnboardingKey)

        // Decide which initial view controller to show
        if hasSeenOnboarding {
            // User has completed onboarding previously -> show main flow
            window.rootViewController = RootRouter.createRootViewController()
        } else {
            // User has NOT seen onboarding -> show onboarding flow
            window.rootViewController = SceneBuilder.buildOnboardingScene()
        }

        window.makeKeyAndVisible()
        self.window = window
    }
}
