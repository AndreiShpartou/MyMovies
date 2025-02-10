//
//  SearchPresenterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol SearchPresenterProtocol: AnyObject {
    var view: SearchViewProtocol? { get set }
    var interactor: SearchInteractorProtocol { get set }
    var router: SearchRouterProtocol { get set }

    func viewDidLoad()
    func didSearch(query: String)
    func didSelectGenre(_ genre: GenreViewModelProtocol)
    func didSelectMovie(movieID: Int)
    func didSelectPerson(personID: Int)
    func didTapSeeAllButton(listType: MovieListType)
}
