//
//  MovieListBuilder.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

protocol MovieListBuilderProtocol: AnyObject {
}

final class MovieListBuilder: MovieListBuilderProtocol {
    static func build() -> UIViewController {
        return MovieListViewController()
    }
}
