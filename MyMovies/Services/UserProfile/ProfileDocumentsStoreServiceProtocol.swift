//
//  ProfileDocumentsStoreServiceProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 06/04/2025.
//

import Foundation

protocol ProfileDocumentsStoreServiceProtocol {
    func setData(collection: String, document: String, data: [String: Any], completion: @escaping (Error?) -> Void)
    func getDocument(collection: String, document: String, completion: @escaping (Result<[String: Any], Error>) -> Void)
    func updateData(collection: String, document: String, data: [String: Any], completion: @escaping (Error?) -> Void)

    @discardableResult
    func addSnapshotListener(collection: String, document: String, completion: @escaping (Result<[String: Any], Error>) -> Void) -> NSObjectProtocol?
    func removeSnapshotListener(_ handle: NSObjectProtocol?)
}
