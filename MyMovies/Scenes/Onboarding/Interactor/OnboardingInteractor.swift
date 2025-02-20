//
//  OnboardingInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 20/02/2025.
//

import Foundation

final class OnboardingInteractor: OnboardingInteractorProtocol {
    weak var presenter: OnboardingInteractorOutputProtocol?
    // MARK: - Init
    init(presenter: OnboardingInteractorOutputProtocol? = nil) {
        self.presenter = presenter
    }
    // MARK: - Public
    func markOnboardingAsCompleted() {
        //
    }

    // MARK: - Private
}
