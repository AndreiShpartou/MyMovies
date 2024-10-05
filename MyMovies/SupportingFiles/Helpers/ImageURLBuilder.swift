//
//  ImageURLBuilder.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 09/08/2024.
//

import Foundation

protocol ImageSizeType {
    var rawValue: String { get }
}

enum BackdropSize: String, ImageSizeType {
    case w300
    case w780
    case w1280
    case original
}

enum PosterSize: String, ImageSizeType {
    case w92
    case w154
    case w185
    case w342
    case w500
    case w780
    case original
}

enum PersonSize: String, ImageSizeType {
    case w45
    case w185
    case h632
    case original
}

// Builder for different types of images
enum ImageURLBuilder {
    private static let baseImageURL = "https://image.tmdb.org/t/p/"

//    static func buildURL(for path: String, size: ImageSizeType) -> URL? {
//        return URL(string: "\(baseImageURL)\(size.rawValue)\(path)")
//    }

    static func buildURL(for path: String, size: ImageSizeType) -> String {
        return "\(baseImageURL)\(size.rawValue)\(path)"
    }
}
