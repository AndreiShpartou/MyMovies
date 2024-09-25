//
//  MovieDetailsInteractorProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol MovieDetailsInteractorProtocol: AnyObject {
    func fetchMovie()
}

protocol MovieDetailsInteractorOutputProtocol: AnyObject {
    func didFetchMovie(_ movie: MovieProtocol)
}
