//
//  AppConfig.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 15/08/2024.
//

import Foundation

final class AppConfig {
    static let shared = AppConfig()

    private init() {}

    // Main app API
    var apiURL: String = ""

    // MARK: - Public
    func setupConfiguration() {
        let group = DispatchGroup()

        group.enter()
        NetworkHelper.shared.getPublicIPAddress { [weak self] result in
            switch result {
            case .success(let ip):
                debugPrint("Public IP Address: \(ip)")
                self?.handleIPAddress(ip, group: group)
            case .failure(let error):
                debugPrint("Failure to fetch an IP: \(error.localizedDescription)")
                self?.setupAPIForCountry("networkError")
            }
            group.leave()
        }

        // Wait for the API setup to complete or timeout
        let timeoutInterval: TimeInterval = 5.0
        let result = group.wait(timeout: .now() + timeoutInterval)
        if result == .timedOut {
            // Handle timeout - set networkError API URL
            debugPrint("Timed out while setting up the API")
            setupAPIForCountry("networkError")
        }
    }

    // MARK: - Private
    private func handleIPAddress(_ ip: String, group: DispatchGroup) {
        group.enter()
        NetworkHelper.shared.getCountry(for: ip) { [weak self] result in
            switch result {
            case .success(let country):
                self?.setupAPIForCountry(country)
            case .failure(let error):
                debugPrint("Failure to fetch country: \(error.localizedDescription)")
                self?.setupAPIForCountry("networkError")
            }
            group.leave()
        }
    }

    private func setupAPIForCountry(_ country: String) {
        let apiMapping: [String: String] = [
            "RU": "RU_MovieAPI",
            "BY": "RU_MovieAPI",
            "networkError": "RU_MovieAPI",
            "default": "EN_MovieAPI"
        ]

        let key = apiMapping[country] ?? apiMapping["default"] ?? ""
        self.apiURL = Bundle.main.object(forInfoDictionaryKey: key) as? String ?? ""
    }
}
