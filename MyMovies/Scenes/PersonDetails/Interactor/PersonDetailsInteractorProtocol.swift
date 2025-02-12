//
//  PersonDetailsInteractorProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 11/02/2025.
//

import Foundation

protocol PersonDetailsInteractorProtocol: AnyObject {
    var presenter: PersonDetailsInteractorOutputProtocol? { get set }

    func fetchDetails()
}

protocol PersonDetailsInteractorOutputProtocol: AnyObject {
    func didFetchPersonDetails(_ person: PersonDetailedProtocol)
    func didFetchRelatedMovies(_ movies: [MovieProtocol])
    func didFailToFetchData(with error: Error)
}
