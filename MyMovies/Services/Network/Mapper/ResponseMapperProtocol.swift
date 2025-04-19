//
//  ResponseMapperProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 20/08/2024.
//

import Foundation

protocol ResponseMapperProtocol {
    func map<T: Codable>(data: Codable, from responseType: Codable.Type, to entitytype: T.Type) throws -> T
}
