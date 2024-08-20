//
//  ResponseMapper.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 20/08/2024.
//

import Foundation

final class ResponseMapper: ResponseMapperProtocol {
    func map<T: Codable>(data: Codable, from responseType: Codable.Type, to entityType: T.Type) throws -> T {
        switch (responseType, entityType) {
        case (let fromType, let toType) where fromType == toType:
            return data as! T
        // genres
        case (is TMDBGenresResponse.Type, is [Genre].Type):
            return map(data as! TMDBGenresResponse) as! T
        default:
            throw NetworkError.unsupportedMappingTypes
        }
    }

    // Genres
    private func map(_ data: TMDBGenresResponse) -> [Genre] {
        return data.genres
    }
}
