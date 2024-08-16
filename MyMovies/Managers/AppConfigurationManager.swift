//
//  AppConfigurationManager.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 15/08/2024.
//

import Foundation

// MARK: - ConfigModels
enum Country: String {
    case russia = "RU"
    case belarus = "BY"
    case unitedKingdom = "GB"
    case networkError = "networkError"
    case defaultCountry = "default"

    // Get Info.plist config property name for country
    var configPlistName: String {
        switch self {
        case .russia, .belarus, .networkError:
            return "RU_MovieAPI"
        default:
            return "EN_MovieAPI"
        }
    }
}

struct APIConfiguration {
    let baseURL: URL
    let endpoints: Endpoints
    let language: String
}

struct Endpoints {
    let popularMovies: String
    let trendingMovies: String
    let newTrailers: String
}

struct AppConfiguration {
    let apiConfig: APIConfiguration
    let country: Country
}

// MARK: - AppConfigurationManager
final class AppConfigurationManager {
    static let shared = AppConfigurationManager()

    private init() {}

    // Main app API
    var currentConfig: AppConfiguration?

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
                self?.setupConfiguration(for: .networkError)
            }
            group.leave()
        }

        // Wait for the API setup to complete or timeout
        let timeoutInterval: TimeInterval = 5.0
        let result = group.wait(timeout: .now() + timeoutInterval)
        if result == .timedOut {
            // Handle timeout - set networkError API URL
            debugPrint("Timed out while setting up the API")
            setupConfiguration(for: .networkError)
        }
    }

    // MARK: - Private
    private func handleIPAddress(_ ip: String, group: DispatchGroup) {
        group.enter()
        NetworkHelper.shared.getCountry(for: ip) { [weak self] result in
            switch result {
            case .success(let country):
                if let country = Country(rawValue: country) {
                    self?.setupConfiguration(for: country)
                } else {
                    self?.setupConfiguration(for: .defaultCountry)
                }
            case .failure(let error):
                debugPrint("Failure to fetch country: \(error.localizedDescription)")
                self?.setupConfiguration(for: .networkError)
            }
            group.leave()
        }
    }

    private func setupConfiguration(for country: Country) {
        guard let apiConfig = loadPlistConfiguration(for: country) else {
            debugPrint("Failed to load configuration for country: \(country.rawValue)")
            return
        }

        currentConfig = AppConfiguration(apiConfig: apiConfig, country: country)
        debugPrint("Configuration set up for country: \(country.rawValue)")
    }

    // Load data from Info.plist
    private func loadPlistConfiguration(for country: Country) -> APIConfiguration? {
        guard let configDict = Bundle.main.object(forInfoDictionaryKey: country.configPlistName) as? [String: Any],
              let baseURLString = configDict["BaseURL"] as? String,
              let baseURL = URL(string: baseURLString),
              let endpointsDict = configDict["Endpoints"] as? [String: String],
              let language = configDict["Language"] as? String else {
            return nil
        }

        let endpoints = Endpoints(
            popularMovies: endpointsDict["PopularMovies"] ?? "",
            trendingMovies: endpointsDict["TrendingMovies"] ?? "",
            newTrailers: endpointsDict["NewTrailers"] ?? ""
        )

        return APIConfiguration(baseURL: baseURL, endpoints: endpoints, language: language)
    }
}
