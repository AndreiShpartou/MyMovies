//
//  ProfileSettingsItem.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 08/10/2024.
//

import UIKit

enum ProfileSettingsItem: CaseIterable {
    case notification
    case language
    case legalAndPolicies
    case aboutUs

    var title: String {
        switch self {
        case .notification:
            return NSLocalizedString("Notification", comment: "Notification settings")
        case .language:
            return NSLocalizedString("Language", comment: "Language settings")
        case .legalAndPolicies:
            return NSLocalizedString("Legal and Policies", comment: "Legal and Policies information")
        case .aboutUs:
            return NSLocalizedString("About Us", comment: "About Us information")
        }
    }

    var icon: UIImage? {
        switch self {
        case .notification:
            return Asset.Icons.notification.image
        case .language:
            return Asset.Icons.globe.image
        case .legalAndPolicies:
            return Asset.Icons.shield.image
        case .aboutUs:
            return Asset.Icons.alert.image
        }
    }

    var plistkey: String? {
        switch self {
        case .legalAndPolicies:
            return "LegalAndPolicies"
        case .aboutUs:
            return "AboutUs"
        default:
            return nil
        }
    }
}
