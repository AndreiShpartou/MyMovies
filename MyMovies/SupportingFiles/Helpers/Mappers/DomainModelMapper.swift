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
        // MoviesToViewModel
        // UpcomingMovies
        case (let data as [MovieProtocol], is [UpcomingMovieViewModel].Type):
            return mapToUpcoming(data) as? Y
        // Popular movies
        case (let data as [MovieProtocol], is [BriefMovieListItemViewModel].Type):
            return mapToBriefList(data) as? Y
        // MovieList
        case (let data as [MovieProtocol], is [MovieListItemViewModel].Type):
            return mapToList(data) as? Y
        // MovieDetails
        case (let data as MovieProtocol, is MovieDetailsViewModel.Type):
            return mapToDetails(data) as? Y
        // Reviews
        case (let data as [MovieReviewProtocol], is [ReviewViewModel].Type):
            return mapToReviews(data) as? Y
        // GenresToViewModel
        case (let data as [GenreProtocol], is [GenreViewModel].Type):
            return map(data) as? Y
        // GenresToDomainModel
        case (let data as GenreViewModelProtocol, is Movie.Genre.Type):
            return map(data) as? Y
        // SettingsToViewModel
        case (let data as [ProfileSettingsSection], is [ProfileSettingsSectionViewModel].Type):
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
                id: $0.id,
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
                id: $0.id,
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
                id: $0.id,
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

    // MovieProtocol -> MovieDetailsViewModelProtocol
    private func mapToDetails(_ data: MovieProtocol) -> MovieDetailsViewModelProtocol {
        let runtime = (data.runtime == "0" || data.runtime == nil) ? String(Int.random(in: 90...120)) : data.runtime!
        return MovieDetailsViewModel(
            id: data.id,
            title: data.title,
            alternativeTitle: data.alternativeTitle,
            description: data.description ?? data.title,
            voteAverage: String(format: "%.1f", data.voteAverage ?? Double.random(in: 4.4...7.7)),
            genre: data.genres.first?.name ?? "Action",
            releaseYear: extractYear(from: data.releaseYear),
            runtime: "\(runtime) Minutes",
            countries: map(data.countries),
            persons: map(data.persons),
            genres: map(data.genres, addDefaultValue: false),
            backdropURL: URL(string: data.backdrop?.url ?? data.poster?.url ?? ""),
            posterURL: URL(string: data.poster?.url ?? "")
        )
    }

    private func mapToReviews(_ data: [MovieReviewProtocol]) -> [ReviewViewModelProtocol] {
        let reviews: [ReviewViewModelProtocol] = data.map {
            ReviewViewModel(author: $0.author, review: $0.review)
        }

        return reviews
    }

    // GenreProtocol -> GenreViewModelProtocol
    private func map(_ data: [GenreProtocol], addDefaultValue: Bool = true) -> [GenreViewModelProtocol] {
        var genreViewModels: [GenreViewModelProtocol] = data.compactMap {
            guard let name = $0.name else {
                return nil
            }

            return GenreViewModel(id: $0.id, name: name)
        }
        if addDefaultValue {
            // Add the "All" genre at the start
            genreViewModels.insert(GenreViewModel(name: "All"), at: 0)
        }

        return genreViewModels
    }

    // [PersonProtocol] -> [PersonViewModelProtocol]
    private func map(_ data: [PersonProtocol]) -> [PersonViewModelProtocol] {
        data.map {
            PersonViewModel(
                id: $0.id,
                photo: URL(string: $0.photo ?? ""),
                name: $0.name,
                originalName: $0.originalName,
                profession: $0.profession
            )
        }
    }

    //  [CountryProtocol] -> [CountryViewModelProtocol]
    private func map(_ data: [CountryProtocol]) -> [CountryViewModelProtocol] {
        data.map { CountryViewModel(name: $0.fullName) }
    }

    //  [ProfileSettingsSection] -> [ProfileSettingsSectionViewModelProtocol]
    private func map(_ data: [ProfileSettingsSection]) -> [ProfileSettingsSectionViewModelProtocol] {
        return data.map {
            let items = $0.items.map {
                ProfileSettingsItemViewModel(icon: $0.icon, title: $0.title)
            }
            return ProfileSettingsSectionViewModel(title: $0.title, items: items)
        }
    }
}

// MARK: - ToDomainModel
extension DomainModelMapper {
    // GenreViewModelProtocol -> GenreProtocol
    private func map(_ data: GenreViewModelProtocol) -> GenreProtocol {
        return Movie.Genre(id: data.id, name: data.name.lowercased())
    }
}
