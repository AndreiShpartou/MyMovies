//
//  AppError.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 30/01/2025.
//

import Foundation

// Custom error definition
enum AppError: Error {
    case unknownError(String)
    case customError(message: String, comment: String)
    // Network / Alamofire
    case networkError(statusCode: Int?, message: String, underlying: Error?)
    case decodingError(message: String, underlying: Error?)
    // Firestore
    case firestoreError(message: String, underlying: NSError)
    // Core Data
    case coreDataError(message: String, underlying: Error?)
    // Custom domain mapping or other
    case mappingError(message: String, underlying: Error?)

//    var errorLocalizedDescription: String {
//        switch self {
//        case .unknownError(let message):
//            return NSLocalizedString("An unknown error occurred: \(message)", comment: "Unknown error")
//        case .customError(let message, let comment):
//            return NSLocalizedString(message, comment: comment)
//        }
//    }
}
