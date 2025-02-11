//
//  PersonDetailsInteractorProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 11/02/2025.
//

import Foundation

protocol PersonDetailsInteractorProtocol: AnyObject {
    var presenter: PersonDetailsInteractorOutputProtocol? { get set }

    func fetchPersonDetails()
}

protocol PersonDetailsInteractorOutputProtocol: AnyObject {
    func didFetchPersonDetails(_ person: PersonDetailsProtocol)
    func didFailToFetchData(with error: Error)
}
