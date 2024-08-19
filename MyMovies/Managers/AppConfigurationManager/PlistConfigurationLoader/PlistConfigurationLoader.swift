//
//  PlistConfigurationLoader.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 19/08/2024.
//

import Foundation

// MARK: - PlistConfigurationLoader
final class PlistConfigurationLoader: PlistConfigurationLoaderProtocol {
    // Load data from Info.plist
    func loadConfiguration(for country: Country) -> APIConfigurationProtocol? {
        guard let configDict = Bundle.main.object(forInfoDictionaryKey: country.configPlistName) as? [String: Any],
              let baseURLString = configDict["BaseURL"] as? String,
              let authorization = configDict["Authorization"] as? [String: String],
              let providerString = configDict["Provider"] as? String,
              let provider = Provider(rawValue: providerString),
              let baseURL = URL(string: baseURLString),
              let endpointsDict = configDict["Endpoints"] as? [String: String] else {
            return nil
        }

        return APIConfiguration(
            baseURL: baseURL,
            authHeader: authorization,
            endpoints: endpointsDict,
            provider: provider,
            language: country.language
        )
    }
}
