//
//  OnboardingView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 20/02/2025.
//

import UIKit

final class OnboardingView: UIView, OnboardingViewProtocol {
    weak var delegate: OnboardingViewDelegate?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - OnboardingViewProtocol
    func configurePages(_ pages: [OnboardingPageViewModelProtocol]) {
        //
    }

    func showPage(at index: Int) {
        //
    }

    func showError() {
        //
    }
}

// MARK: - SetupView
extension OnboardingView {
    private func setupView() {
        backgroundColor = .primaryBackground
    }
}

// MARK: - Constraints
extension OnboardingView {
    private func setupConstraints() {
    }
}
