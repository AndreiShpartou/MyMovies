//
//  MovieDetailsPresenterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol MovieDetailsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapSeeAllButton(listType: MovieListType)
    func didSelectMovie(movieID: Int)
}
