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

    func loadGeneralTextSceneData(for key: String) -> GeneralDetails {
        guard let generalDict = Bundle.main.object(forInfoDictionaryKey: key) as? [String: String],
              let labelText = generalDict["labelText"],
              let textViewText = generalDict["textViewText"],
              let title = generalDict["title"] else {
            return GeneralDetails(labelText: nil, textViewText: nil, title: nil)
        }

        return GeneralDetails(labelText: labelText, textViewText: textViewText, title: title)
    }

    func loadCloudinaryConfig() -> CloudinaryAuth? {
        guard let configDict = Bundle.main.object(forInfoDictionaryKey: "Cloudinary") as? [String: Any],
              let cloudName = configDict["cloudName"] as? String,
              let apiKey = configDict["apiKey"] as? String,
              let apiSecret = configDict["apiSecret"] as? String else {
            return nil
        }

        return CloudinaryAuth(cloudName: cloudName, apiKey: apiKey, apiSecret: apiSecret)
    }
}
