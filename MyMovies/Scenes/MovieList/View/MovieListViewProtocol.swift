//
//  MovieListViewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import UIKit

protocol MovieListViewProtocol: UIView {
    var delegate: MovieListViewDelegate? { get set }
    var presenter: MovieListPresenterProtocol? { get set }
}

protocol MovieListViewDelegate: AnyObject {
}
