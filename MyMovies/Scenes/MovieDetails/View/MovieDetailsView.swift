//
//  MovieDetailsView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

protocol MovieDetailsViewProtocol: AnyObject {
}

class MovieDetailsView: UIView {
    var presenter: MovieDetailsPresenterProtocol?
}
