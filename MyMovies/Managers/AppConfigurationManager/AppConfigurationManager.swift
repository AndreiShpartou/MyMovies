//
//  AppConfigurationManager.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 15/08/2024.
//

import Foundation

// MARK: - AppConfigurationManager
final class AppConfigurationManager: AppConfigurationManagerProtocol {
    static let shared = AppConfigurationManager(
        networkHelper: NetworkHelper.shared,
        plistLoader: PlistConfigurationLoader()
    )
    // Main app configuration
    var appConfig: AppConfigurationProtocol?
    // Initial configuration helpers
    private let networkHelper: NetworkHelperProtocol
    private let plistLoader: PlistConfigurationLoaderProtocol

    private init(
        networkHelper: NetworkHelperProtocol,
        plistLoader: PlistConfigurationLoaderProtocol
    ) {
        self.networkHelper = networkHelper
        self.plistLoader = plistLoader
    }

    // MARK: - Public
    func setupConfiguration() {
        let group = DispatchGroup()

        group.enter()
        networkHelper.getPublicIPAddress { [weak self] result in
            switch result {
            case .success(let ip):
                debugPrint("Public IP Address: \(ip)")
                self?.fetchCountryAndSetupConfig(for: ip, group: group)
            case .failure(let error):
                debugPrint("Failure to fetch an IP: \(error.localizedDescription)")
                self?.setupDefaultConfiguration()
            }
            group.leave()
        }

        // Wait for the API setup to complete or timeout
        let timeoutInterval: TimeInterval = 5.0
        let result = group.wait(timeout: .now() + timeoutInterval)
        if result == .timedOut {
            // Handle timeout - set networkError API URL
            debugPrint("Timed out while setting up the API")
            setupDefaultConfiguration()
        }
    }

    // MARK: - Private
    // Get country by IP
    private func fetchCountryAndSetupConfig(for ip: String, group: DispatchGroup) {
        group.enter()
        networkHelper.getCountry(for: ip) { [weak self] result in
            switch result {
            case .success(let country):
                let country = Country(rawValue: country) ?? .defaultCountry
                self?.setupConfiguration(for: country)
            case .failure(let error):
                debugPrint("Failure to fetch country: \(error.localizedDescription)")
                self?.setupDefaultConfiguration()
            }
            group.leave()
        }
    }

    private func setupDefaultConfiguration() {
        setupConfiguration(for: .networkError)
    }

    // Choose configuration by country
    private func setupConfiguration(for country: Country) {
        guard let apiConfig = plistLoader.loadConfiguration(for: country) else {
            debugPrint("Failed to load configuration for country: \(country.rawValue)")
            return
        }

        appConfig = AppConfiguration(apiConfig: apiConfig, language: country.language)
        debugPrint("Configuration set up for country: \(country.rawValue)")
    }
}
