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
        // moviesToViewModel
        // UpcomingMovies
        case (let data as [MovieProtocol], is [UpcomingMovieViewModel].Type):
            return mapToUpcoming(data) as? Y
        // Popular movies
        case (let data as [MovieProtocol], is [BriefMovieListItemViewModel].Type):
            return mapToBriefList(data) as? Y
        // MovieList
        case (let data as [MovieProtocol], is [MovieListItemViewModel].Type):
            return mapToList(data) as? Y
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
    // MovieProtocol -> UpcomingMovieViewModelProtocol
    private func mapToUpcoming(_ data: [MovieProtocol]) -> [UpcomingMovieViewModelProtocol] {
        let movieViewModels: [UpcomingMovieViewModel] = data.map {
            return UpcomingMovieViewModel(
                title: $0.title,
                shortDescription: $0.shortDescription,
                posterURL: URL(string: $0.poster?.url ?? ""),
                backdropURL: URL(string: $0.backdrop?.url ?? "")
            )
        }

        return movieViewModels
    }

    // MovieProtocol -> BriefMovieListItemViewModelProtocol
    private func mapToBriefList(_ data: [MovieProtocol]) -> [BriefMovieListItemViewModelProtocol] {
        let movieViewModels: [BriefMovieListItemViewModel] = data.map {
            return BriefMovieListItemViewModel(
                title: $0.title,
                posterURL: URL(string: $0.poster?.url ?? ""),
                genre: $0.genres.first?.name ?? "Action",
                voteAverage: String(format: "%.1f", $0.voteAverage ?? Double.random(in: 4.4...7.7))
            )
        }

        return movieViewModels
    }

    // MovieProtocol -> MovieListViewModelProtocol
    private func mapToList(_ data: [MovieProtocol]) -> [MovieListItemViewModelProtocol] {
        let movieViewModels: [MovieListItemViewModel] = data.map {
            let runtime = ($0.runtime == "0" || $0.runtime == nil) ? String(Int.random(in: 90...120)) : $0.runtime!
            return MovieListItemViewModel(
                title: $0.title,
                voteAverage: String(format: "%.1f", $0.voteAverage ?? Double.random(in: 4.4...7.7)),
                genre: $0.genres.first?.name ?? "Action",
                countries: $0.countries.map { $0.name },
                posterURL: URL(string: $0.poster?.url ?? ""),
                releaseYear: extractYear(from: $0.releaseYear),
                runtime: "\(runtime) Minutes"
            )
        }

        return movieViewModels
    }

    // GenreProtocol -> GenreViewModelProtocol
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
    // GenreViewModelProtocol -> GenreProtocol
    private func map(_ data: GenreViewModelProtocol) -> GenreProtocol {
        return Movie.Genre(id: data.id, name: data.name.lowercased())
    }
}
