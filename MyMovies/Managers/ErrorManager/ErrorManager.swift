//
//  ErrorManager.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 03/04/2025.
//

import Foundation

enum ErrorManager {
    static func toAppError(_ error: Error) -> AppError {
        if let appError = error as? AppError {
            return appError
        }

        // Firestore, Cloudinary (NSError)
        if let nsError = error as NSError?,
           nsError.domain == "FirebaseErrorDomain" ||
            nsError.domain == "CLDCloudinaryErrorDomain" {
            if let message = nsError.userInfo["message"] as? String {
                return .firestoreError(message: message, underlying: nsError)
            } else {
                return .firestoreError(message: nsError.localizedDescription, underlying: nsError)
            }
        }

        // Alamofire (AFError)
        if let afError = error as? URLError {
            // Parse afError.code or afError.localizedDescription
            return .networkError(
                statusCode: nil,
                message: afError.localizedDescription,
                underlying: afError
            )
        }

        // Core Data (NSError)
        if let nsError = error as NSError?, nsError.domain == NSCocoaErrorDomain {
            return .coreDataError(message: nsError.localizedDescription, underlying: nsError)
        }

        // Decoding error (JSONDecoder)
        if let decodingError = error as? DecodingError {
            // We can parse the decodingError to get a more precise message if we want
            return .decodingError(message: decodingError.localizedDescription, underlying: decodingError)
        }

        return .unknownError(error.localizedDescription)
    }

    // Convert an error to user message
    static func toUseMessage(from appError: AppError) -> String {
        switch appError {
        case .unknownError(let message):
            return NSLocalizedString("Something went wrong. Please try again. \(message)", comment: "Unknown error")
        case .networkError(let statusCode, let message, _):
            if let code = statusCode {
                return NSLocalizedString("Network error: \(code) – \(message)", comment: "")
            } else {
                return NSLocalizedString("Network request failed. \(message)", comment: "")
            }
        case .decodingError(let message, _):
            return NSLocalizedString("Failed to parse server response. \(message)", comment: "Decoding error")
        case .firestoreError(let message, _):
            return message
        case .coreDataError(let message, _):
            return NSLocalizedString("Database Error: \(message)", comment: "")
        case .mappingError(let message, _):
            return NSLocalizedString("Mapping Error: \(message)", comment: "")
        case .customError(let message, _):
            return NSLocalizedString(message, comment: "Custom error")
        }
    }
}
