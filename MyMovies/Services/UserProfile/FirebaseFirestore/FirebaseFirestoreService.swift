//
//  FirebaseFirestoreService.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 06/04/2025.
//

import FirebaseFirestore

final class FirebaseFirestoreService: ProfileDocumentsStoreServiceProtocol {
    // MARK: - ProfileDocumentsStoreService
    private let firestore: Firestore

    init(firestore: Firestore = Firestore.firestore()) {
        self.firestore = firestore
    }

    func setData(collection: String, document: String, data: [String: Any], completion: @escaping (Error?) -> Void) {
        firestore.collection(collection).document(document).setData(data, completion: completion)
    }

    func getDocument(collection: String, document: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        firestore.collection(collection).document(document).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let userData = snapshot?.data(),
                    (userData["name"] as? String) != nil {
                completion(.success(userData))
            } else {
                completion(.failure(AppError.customError(message: "No data found", comment: "")))
            }
        }
    }

    func updateData(collection: String, document: String, data: [String: Any], completion: @escaping (Error?) -> Void) {
        firestore.collection(collection).document(document).updateData(data, completion: completion)
    }

    // MARK: - Observers
    func addSnapshotListener(collection: String, document: String, completion: @escaping (Result<[String: Any], Error>) -> Void) -> NSObjectProtocol? {
        return firestore.collection(collection).document(document).addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let userData = snapshot?.data(),
                    (userData["name"] as? String) != nil {
                completion(.success(userData))
            } else {
                completion(.failure(AppError.customError(message: "No data found", comment: "")))
            }
        }
    }

    func removeSnapshotListener(_ handle: NSObjectProtocol?) {
        (handle as? ListenerRegistration)?.remove()
    }
}
