//
//  SearchView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

class SearchView: UIView {
    var presenter: SearchPresenterProtocol?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
extension SearchView {
    private func setupView() {
    }
}

// MARK: - Constraints
extension SearchView {
    private func setupConstraints() {
    }
}
