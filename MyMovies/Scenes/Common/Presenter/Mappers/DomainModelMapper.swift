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
        case (let data as [Movie], is [UpcomingMovieViewModel].Type):
            return mapToUpcoming(data) as? Y
        // Popular movies
        case (let data as [Movie], is [BriefMovieListItemViewModel].Type):
            return mapToBriefList(data) as? Y
        case (let data as [Movie], is [WishlistItemViewModel].Type):
            return mapToWishlistItem(data) as? Y
        // MovieList
        case (let data as [Movie], is [MovieListItemViewModel].Type):
            return mapToList(data) as? Y
        case (let data as Movie, is MovieListItemViewModel.Type):
            return mapToList(data) as? Y
        // MovieDetails
        case (let data as Movie, is MovieDetailsViewModel.Type):
            return mapToDetails(data) as? Y
        case (let data as Movie, is UpcomingMovieViewModel.Type):
            return mapToUpcoming(data) as? Y
        // Reviews
        case (let data as [MovieReview], is [ReviewViewModel].Type):
            return mapToReviews(data) as? Y
        // Persons
        case (let data as [Person], is [PersonViewModel].Type):
            return map(data) as? Y
        case (let data as PersonDetailed, is PersonDetailedViewModel.Type):
            return map(data) as? Y
        // GenresToViewModel
        case (let data as [Genre], is [GenreViewModel].Type):
            return map(data) as? Y
        // GenresToDomainModel
        case (let data as GenreViewModel, is Genre.Type):
            return map(data) as? Y
        // UserProfileToViewModel
        case (let data as UserProfile, is UserProfileViewModel.Type):
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
    // [Movie] -> [UpcomingMovieViewModel]
    private func mapToUpcoming(_ data: [Movie]) -> [UpcomingMovieViewModel] {
        let movieViewModels = data.map {
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

    // Movie -> UpcomingMovieViewModel
    private func mapToUpcoming(_ data: Movie) -> UpcomingMovieViewModel {
        return UpcomingMovieViewModel(
            id: data.id,
            title: data.title,
            shortDescription: data.shortDescription,
            posterURL: URL(string: data.poster?.url ?? ""),
            backdropURL: URL(string: data.backdrop?.url ?? "")
        )
    }

    // Movie -> BriefMovieListItemViewModel
    private func mapToBriefList(_ data: [Movie]) -> [BriefMovieListItemViewModel] {
        let movieViewModels = data.map {
            return BriefMovieListItemViewModel(
                id: $0.id,
                title: $0.title,
                posterURL: URL(string: $0.poster?.url ?? ""),
                genre: $0.genres.first?.name ?? "N/A",
                voteAverage: String(format: "%.1f", $0.voteAverage ?? Double.random(in: 4.4...7.7))
            )
        }

        return movieViewModels
    }

    // Movie -> WishlistItemViewModel
    private func mapToWishlistItem(_ data: [Movie]) -> [WishlistItemViewModel] {
        let movieViewModels = data.map {
            return WishlistItemViewModel(
                id: $0.id,
                title: $0.title,
                posterURL: URL(string: $0.backdrop?.url ?? $0.poster?.url ?? ""),
                genre: $0.genres.first?.name ?? "N/A",
                voteAverage: String(format: "%.1f", $0.voteAverage ?? Double.random(in: 4.4...7.7)),
                year: extractYear(from: $0.releaseYear)
            )
        }

        return movieViewModels
    }

    // [Movie] -> [MovieListViewModel]
    private func mapToList(_ data: [Movie]) -> [MovieListItemViewModel] {
        let movieViewModels = data.map {
            let runtime = ($0.runtime == "0" || $0.runtime == nil) ? String(Int.random(in: 90...120)) : $0.runtime!
            return MovieListItemViewModel(
                id: $0.id,
                title: $0.title,
                voteAverage: String(format: "%.1f", $0.voteAverage ?? Double.random(in: 4.4...7.7)),
                genre: $0.genres.first?.name ?? "N/A",
                countries: $0.countries.map { $0.name },
                posterURL: URL(string: $0.poster?.url ?? ""),
                releaseYear: extractYear(from: $0.releaseYear),
                runtime: "\(runtime) Minutes"
            )
        }

        return movieViewModels
    }

    // Movie -> MovieListViewModel
    private func mapToList(_ data: Movie) -> MovieListItemViewModel {
            let runtime = (data.runtime == "0" || data.runtime == nil) ? String(Int.random(in: 90...120)) : data.runtime!
            return MovieListItemViewModel(
                id: data.id,
                title: data.title,
                voteAverage: String(format: "%.1f", data.voteAverage ?? Double.random(in: 4.4...7.7)),
                genre: data.genres.first?.name ?? "N/A",
                countries: data.countries.map { $0.name },
                posterURL: URL(string: data.poster?.url ?? ""),
                releaseYear: extractYear(from: data.releaseYear),
                runtime: "\(runtime) Minutes"
            )
    }

    // Movie -> MovieDetailsViewModel
    private func mapToDetails(_ data: Movie) -> MovieDetailsViewModel {
        let runtime = (data.runtime == "0" || data.runtime == nil) ? String(Int.random(in: 90...120)) : data.runtime!
        return MovieDetailsViewModel(
            id: data.id,
            title: data.title,
            alternativeTitle: data.alternativeTitle,
            description: data.description ?? data.title,
            voteAverage: String(format: "%.1f", data.voteAverage ?? Double.random(in: 4.4...7.7)),
            genre: data.genres.first?.name ?? "N/A",
            releaseYear: extractYear(from: data.releaseYear),
            runtime: "\(runtime) Minutes",
            countries: map(data.countries),
            persons: map(data.persons),
            genres: map(data.genres, addDefaultValue: false),
            backdropURL: URL(string: data.backdrop?.url ?? data.poster?.url ?? ""),
            posterURL: URL(string: data.poster?.url ?? "")
        )
    }

    // MovieReview -> ReviewViewModel
    private func mapToReviews(_ data: [MovieReview]) -> [ReviewViewModel] {
        let reviews = data.map {
            ReviewViewModel(author: $0.author, review: $0.review)
        }

        return reviews
    }

    // Genre -> GenreViewModel
    private func map(_ data: [Genre], addDefaultValue: Bool = true) -> [GenreViewModel] {
        var genreViewModels: [GenreViewModel] = data.compactMap {
            guard let name = $0.name else {
                return nil
            }

            return GenreViewModel(id: $0.id, name: name)
        }
        if !genreViewModels.isEmpty, addDefaultValue {
            // Add the "All" genre at the start
            genreViewModels.insert(GenreViewModel(name: "All"), at: 0)
        }

        return genreViewModels
    }

    // [Person] -> [PersonViewModel]
    private func map(_ data: [Person]) -> [PersonViewModel] {
        return data.map {
            PersonViewModel(
                id: $0.id,
                photo: URL(string: $0.photo ?? ""),
                name: $0.name,
                profession: $0.profession,
                popularity: $0.popularity ?? 0
            )
        }
    }

    // PersonDetailed -> PersonDetailedViewModel
    private func map(_ data: PersonDetailed) -> PersonDetailedViewModel {
        return PersonDetailedViewModel(
            id: data.id,
            name: data.name,
            photo: data.photo?.sanitizedURL,
            birthDay: unifiedDateString(from: data.birthDay),
            birthPlace: data.birthPlace,
            deathDay: unifiedDateString(from: data.deathDay),
            department: data.department
        )
    }

    //  [Country] -> [CountryViewModel]
    private func map(_ data: [ProductionCountry]) -> [CountryViewModel] {
        return data.map { CountryViewModel(name: $0.fullName) }
    }

    //  [ProfileSettingsSection] -> [ProfileSettingsSectionViewModel]
    private func map(_ data: [ProfileSettingsSection]) -> [ProfileSettingsSectionViewModel] {
        return data.map {
            let items = $0.items.map {
                ProfileSettingsItemViewModel(icon: $0.icon, title: $0.title)
            }
            return ProfileSettingsSectionViewModel(title: $0.title, items: items)
        }
    }

    //  UserProfile -> UserProfileViewModel
    private func map(_ data: UserProfile) -> UserProfileViewModel {
        return UserProfileViewModel(
            id: data.id,
            email: data.email,
            name: data.name,
            profileImageURL: data.profileImageURL
        )
    }
}

// MARK: - ToDomainModel
extension DomainModelMapper {
    // GenreViewModelProtocol -> GenreProtocol
    private func map(_ data: GenreViewModel) -> Genre {
        return Genre(id: data.id, name: data.name.lowercased())
    }
}
