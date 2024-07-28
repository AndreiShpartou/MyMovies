//
//  MainView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

protocol MainViewProtocol: AnyObject {}

final class MainView: UIView {
    var presenter: MainPresenterProtocol?
    
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
extension MainView {
    private func setupView() {
    }
}

// MARK: - Constraints
extension MainView {
    private func setupConstraints() {
    }
}
