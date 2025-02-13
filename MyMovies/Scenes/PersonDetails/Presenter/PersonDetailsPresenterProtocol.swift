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
    func didSelectGenre(_ genre: GenreViewModelProtocol)
    func didSelectMovie(movie: MovieProtocol)
    func didTapSeeAllButton(listType: MovieListType)
}
