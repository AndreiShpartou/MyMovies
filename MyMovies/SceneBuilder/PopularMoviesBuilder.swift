//
//  PopularMoviesBuilder.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

protocol PopularMoviesBuilderProtocol: AnyObject {
}

final class PopularMoviesBuilder: PopularMoviesBuilderProtocol {
    static func build() -> UIViewController {
        return PopularMoviesViewController()
    }
}
