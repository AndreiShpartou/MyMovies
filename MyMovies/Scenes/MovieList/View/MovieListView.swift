//
//  MovieListView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

protocol MovieListViewProtocol: AnyObject {
}

class MovieListView: UIView {
    var presenter: MovieListPresenterProtocol?
}
