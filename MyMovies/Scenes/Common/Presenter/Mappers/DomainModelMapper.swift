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
        case (let data as [MovieProtocol], is [WishlistItemViewModel].Type):
            return mapToWishlistItem(data) as? Y
        // MovieList
        case (let data as [MovieProtocol], is [MovieListItemViewModel].Type):
            return mapToList(data) as? Y
        case (let data as MovieProtocol, is MovieListItemViewModel.Type):
            return mapToList(data) as? Y
        // MovieDetails
        case (let data as MovieProtocol, is MovieDetailsViewModel.Type):
            return mapToDetails(data) as? Y
        case (let data as MovieProtocol, is UpcomingMovieViewModel.Type):
            return mapToUpcoming(data) as? Y
        // Reviews
        case (let data as [MovieReviewProtocol], is [ReviewViewModel].Type):
            return mapToReviews(data) as? Y
        // Persons
        case (let data as [PersonProtocol], is [PersonViewModel].Type):
            return map(data) as? Y
        case (let data as PersonDetailedProtocol, is PersonDetailedViewModel.Type):
            return map(data) as? Y
        // GenresToViewModel
        case (let data as [GenreProtocol], is [GenreViewModel].Type):
            return map(data) as? Y
        // GenresToDomainModel
        case (let data as GenreViewModelProtocol, is Movie.Genre.Type):
            return map(data) as? Y
        // UserProfileToViewModel
        case (let data as UserProfileProtocol, is UserProfileViewModel.Type):
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
    // [MovieProtocol] -> [UpcomingMovieViewModelProtocol]
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

    // MovieProtocol -> UpcomingMovieViewModelProtocol
    private func mapToUpcoming(_ data: MovieProtocol) -> UpcomingMovieViewModelProtocol {
        return UpcomingMovieViewModel(
            id: data.id,
            title: data.title,
            shortDescription: data.shortDescription,
            posterURL: URL(string: data.poster?.url ?? ""),
            backdropURL: URL(string: data.backdrop?.url ?? "")
        )
    }

    // MovieProtocol -> BriefMovieListItemViewModelProtocol
    private func mapToBriefList(_ data: [MovieProtocol]) -> [BriefMovieListItemViewModelProtocol] {
        let movieViewModels: [BriefMovieListItemViewModel] = data.map {
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

    // MovieProtocol -> WishlistItemViewModelProtocol
    private func mapToWishlistItem(_ data: [MovieProtocol]) -> [WishlistItemViewModelProtocol] {
        let movieViewModels: [WishlistItemViewModel] = data.map {
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

    // [MovieProtocol] -> [MovieListViewModelProtocol]
    private func mapToList(_ data: [MovieProtocol]) -> [MovieListItemViewModelProtocol] {
        let movieViewModels: [MovieListItemViewModel] = data.map {
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

    // MovieProtocol -> MovieListViewModelProtocol
    private func mapToList(_ data: MovieProtocol) -> MovieListItemViewModelProtocol {
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

    // MovieProtocol -> MovieDetailsViewModelProtocol
    private func mapToDetails(_ data: MovieProtocol) -> MovieDetailsViewModelProtocol {
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
        if !genreViewModels.isEmpty, addDefaultValue {
            // Add the "All" genre at the start
            genreViewModels.insert(GenreViewModel(name: "All"), at: 0)
        }

        return genreViewModels
    }

    // [PersonProtocol] -> [PersonViewModelProtocol]
    private func map(_ data: [PersonProtocol]) -> [PersonViewModelProtocol] {
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

    // PersonDetailedProtocol -> PersonDetailedViewModelProtocol
    private func map(_ data: PersonDetailedProtocol) -> PersonDetailedViewModelProtocol {
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

    //  [CountryProtocol] -> [CountryViewModelProtocol]
    private func map(_ data: [CountryProtocol]) -> [CountryViewModelProtocol] {
        return data.map { CountryViewModel(name: $0.fullName) }
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

    //  UserProfileProtocol -> UserProfileViewModelProtocol
    private func map(_ data: UserProfileProtocol) -> UserProfileViewModelProtocol {
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
    private func map(_ data: GenreViewModelProtocol) -> GenreProtocol {
        return Movie.Genre(id: data.id, name: data.name.lowercased())
    }
}
