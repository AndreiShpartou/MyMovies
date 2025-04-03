//
//  ErrorManager.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 03/04/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum ErrorManager {
    static func toAppError(_ error: Error) -> AppError {
        if let appError = error as? AppError {
            return appError
        }

        // FirebaseAuth
        if let nsError = error as NSError?, nsError.domain == "FIRAuthErrorDomain" {
            switch nsError.code {
            case AuthErrorCode.invalidCredential.rawValue:
                return .firestoreError(message: "Invalid credential", underlying: nsError)
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                return .firestoreError(message: "Email already in use", underlying: nsError)
            case AuthErrorCode.wrongPassword.rawValue:
                return .firestoreError(message: "Wrong password", underlying: nsError)
            case AuthErrorCode.userNotFound.rawValue:
                return .firestoreError(message: "User not found", underlying: nsError)
            case AuthErrorCode.invalidEmail.rawValue:
                return .firestoreError(message: "Invalid email", underlying: nsError)
            case AuthErrorCode.weakPassword.rawValue:
                return .firestoreError(message: "Weak password", underlying: nsError)
            case AuthErrorCode.internalError.rawValue:
                return .firestoreError(message: "Password must contain at least 6 characters", underlying: nsError)
            default:
                return .firestoreError(message: nsError.localizedDescription, underlying: nsError)
            }
        }

        // Firestore and Cloudinary (NSError)
        if let nsError = error as NSError?,
           nsError.domain == "com.cloudinary.error" ||
            nsError.domain == "FIRFirestoreErrorDomain" {
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
    static func toUserMessage(from appError: AppError) -> String {
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
            return NSLocalizedString(message, comment: "")
        }
    }
}
