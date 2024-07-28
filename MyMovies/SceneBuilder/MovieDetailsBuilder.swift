//
//  MovieDetailsBuilder.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

protocol MovieDetailsBuilderProtocol: AnyObject {
}

final class MovieDetailsBuilder: MovieDetailsBuilderProtocol {
    static func build() -> UIViewController {
        return MovieDetailsViewController()
    }
}
