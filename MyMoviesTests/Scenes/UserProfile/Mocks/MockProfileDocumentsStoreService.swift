//
//  MockProfileDocumentsStoreService.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 07/04/2025.
//
import ObjectiveC
@testable import MyMovies

// MARK: - MockProfileDocumentsStoreService
final class MockProfileDocumentsStoreService: ProfileDocumentsStoreServiceProtocol {
    var didCallSetData: Bool = false
    var didCallGetDocument: Bool = false
    var didCallUpdateData: Bool = false
    var capturedCollection: String?
    var capturedDocument: String?
    var capturedData: [String: Any]?
    
    var shouldFailOnSetData = false
    var shouldFailOnGetDocument = false
    var shouldFailOnUpdateData = false
    
    // MARK: - ProfileDocumentsStoreServiceProtocol
    func setData(collection: String, document: String, data: [String: Any], completion: @escaping (Error?) -> Void) {
        didCallSetData = true
        capturedCollection = collection
        capturedDocument = document
        capturedData = data
        
        if shouldFailOnSetData {
            completion(AppError.customError(message: "Failed to set data", comment: ""))
        }
    }
    

    func getDocument(collection: String, document: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        didCallGetDocument = true
        capturedCollection = collection
        capturedDocument = document
        
        if shouldFailOnGetDocument {
            completion(.failure(AppError.customError(message: "Failed to get document", comment: "")))
        } else {
            completion(.success(["name": "MockName", "email": "MockEmail"]))
        }
    }

    func updateData(collection: String, document: String, data: [String: Any], completion: @escaping (Error?) -> Void) {
        didCallUpdateData = true
        capturedCollection = collection
        capturedDocument = document
        capturedData = data
        
        if shouldFailOnUpdateData {
            completion(AppError.customError(message: "Failed to update data", comment: ""))
        }
    }

    // Observers
    @discardableResult
    func addSnapshotListener(collection: String, document: String, completion: @escaping (Result<[String: Any], Error>) -> Void) -> NSObjectProtocol? { return nil }
    func removeSnapshotListener(_ handle: NSObjectProtocol?) {}
}
