//
//  MovieDetailsPresenterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol MovieDetailsPresenterProtocol: AnyObject {
    var view: MovieDetailsViewProtocol? { get set }
    var interactor: MovieDetailsInteractorProtocol { get set }
    var router: MovieDetailsRouterProtocol { get set }

    func viewDidLoad()
    func didTapSeeAllButton(listType: MovieListType)
    func didSelectMovie(movieID: Int)
    func presentReview(with author: String?, and text: String?)
}
