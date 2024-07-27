//
//  PopularMoviesPresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

protocol PopularMoviesPresenterProtocol: AnyObject {
    
}

class PopularMoviesPresenter: PopularMoviesPresenterProtocol {
    weak var view: PopularMoviesViewProtocol?
    var interactor: PopularMoviesInteractorProtocol?
    var router: PopularMoviesRouterProtocol?
}
