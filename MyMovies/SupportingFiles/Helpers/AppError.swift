//
//  AppError.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 30/01/2025.
//

import Foundation

// Custom error definition
enum AppError: Error, LocalizedError {
    case unknownError(message: String)
    case customError(message: String, comment: String)

    var errorLocalizedDescription: String {
        switch self {
        case .unknownError(let message):
            return NSLocalizedString("An unknown error occurred: \(message)", comment: "Unknown error")
        case .customError(let message, let comment):
            return NSLocalizedString(message, comment: comment)
        }
    }
}
