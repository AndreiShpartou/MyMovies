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
        NetworkHelper.shared.getPublicIPAddress { [weak self] result in
            switch result {
            case .success(let ip):
                debugPrint("Public IP Address: \(ip)")
                NetworkHelper.shared.getCountry(for: ip) { result in
                    switch result {
                    case .success(let country):
                        self?.setupAPIForCountry(country)
                    case .failure(let error):
                        debugPrint("Failure to fetch country: \(error.localizedDescription)")
                        self?.setupAPIForCountry("default")
                    }
                }
            case .failure(let error):
                debugPrint("Failure to fetch an IP: \(error.localizedDescription)")
                self?.setupAPIForCountry("default")
            }
        }
    }

    // MARK: - Private
    private func setupAPIForCountry(_ country: String) {
        let apiURL: String?

        switch country {
        case "RU", "BY":
            apiURL = Bundle.main.object(forInfoDictionaryKey: "RU_MovieAPI") as? String
        default:
            apiURL = Bundle.main.object(forInfoDictionaryKey: "EN_MovieAPI") as? String
        }

        guard let apiURL = apiURL else {
            return
        }

        self.apiURL = apiURL
    }
}
