//
//  MainPresenterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    var view: MainViewProtocol? { get set }
    var interactor: MainInteractorProtocol { get set }
    var router: MainRouterProtocol { get set }

    func viewDidLoad()
    func didSelectUpcomingMovie(_ movie: MovieProtocol)
    func didSelectGenre(_ genre: GenreViewModelProtocol)
    func didSelectMovie(_ movie: MovieProtocol)
    func didTapSeeAllButton(listType: MovieListType)
}
