//
//  DomainModelMapper.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 18/09/2024.
//

import Foundation

final class DomainModelMapper: DomainModelMapperProtocol {
    func map<T, Y>(data: T, to returnType: Y.Type) -> Y? {
        switch (data, returnType) {
        // movies
        // genresToViewModel
        case (let data as [GenreProtocol], is [GenreViewModel].Type):
            return map(data) as? Y
        // genresToDomainModel
        case (let data as GenreViewModelProtocol, is Movie.Genre.Type):
            return map(data) as? Y
        default:
            return nil
        }
    }
}

// MARK: - ToViewModel
extension DomainModelMapper {
    private func map(_ data: [GenreProtocol]) -> [GenreViewModelProtocol] {
        var genreViewModels: [GenreViewModelProtocol] = data.compactMap {
            guard let name = $0.name else {
                return nil
            }

            return GenreViewModel(id: $0.id, name: name)
        }
        // Add the "All" genre at the start
        genreViewModels.insert(GenreViewModel(name: "All"), at: 0)

        return genreViewModels
    }
}

// MARK: - ToDomainModel
extension DomainModelMapper {
    private func map(_ data: GenreViewModelProtocol) -> GenreProtocol {
        return Movie.Genre(id: data.id, name: data.name.lowercased())
    }
}
