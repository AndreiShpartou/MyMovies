//
//  PersonDetailsPresenterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 11/02/2025.
//

import Foundation

protocol PersonDetailsPresenterProtocol: AnyObject {
    var view: PersonDetailsViewProtocol? { get set }
    var interactor: PersonDetailsInteractorProtocol { get set }
    var router: PersonDetailsRouterProtocol { get set }

    func viewDidLoad()
    func didTapSeeAllButton(listType: MovieListType)
    func didSelectMovie(movie: MovieProtocol)
}
