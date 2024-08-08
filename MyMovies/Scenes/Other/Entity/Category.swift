//
//  Category.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 07/08/2024.
//

import Foundation

enum Category: String, CaseIterable {
    case movies = "Movies"
    case series = "Series"
    case revenue = "Revenue"
    case awards = "Awards"
    case onlineCinema = "Online cinema"

    var queryParam: String {
        switch self {
        case .onlineCinema:
            return "онлайн-кинотеатр"
        case .awards:
            return "премии"
        case .revenue:
            return "сборы"
        case .series:
            return "сериалы"
        case .movies:
            return "фильмы"
        }
    }
}
