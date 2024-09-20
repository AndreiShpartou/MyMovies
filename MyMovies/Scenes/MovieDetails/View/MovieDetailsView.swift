//
//  MovieDetailsView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

final class MovieDetailsView: UIView, MovieDetailsViewProtocol {
    var presenter: MovieDetailsPresenterProtocol?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
extension MovieDetailsView {
    private func setupView() {
    }
}

// MARK: - Constraints
extension MovieDetailsView {
    private func setupConstraints() {
    }
}
