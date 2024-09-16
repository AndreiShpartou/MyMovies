//
//  MovieListPresenterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol MovieListPresenterProtocol: AnyObject {
    var view: MovieListViewProtocol? { get set }
    var interactor: MovieListInteractorProtocol { get set }
    var router: MovieListRouterProtocol { get set }

    func viewDidLoad(listType: MovieListType)
}
