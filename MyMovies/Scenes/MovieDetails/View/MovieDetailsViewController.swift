//
//  MovieDetailsViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    var presenter: MovieDetailsPresenterProtocol?

    private let movieDetailsView: MovieDetailsViewProtocol

    // MARK: - Init
    init(movieDetailsView: MovieDetailsViewProtocol) {
        self.movieDetailsView = movieDetailsView

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
