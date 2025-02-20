//
//  OnboardingInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 20/02/2025.
//

import Foundation

final class OnboardingInteractor: OnboardingInteractorProtocol {
    weak var presenter: OnboardingInteractorOutputProtocol?

    private let userDefaults = UserDefaults.standard
    private let onboardingKey = "HasSeenOnboarding"

    // MARK: - Init
    init(presenter: OnboardingInteractorOutputProtocol? = nil) {
        self.presenter = presenter
    }
    // MARK: - Public
    func fetchOnboardingData() {
        presenter?.didFetchOnboardingData()
    }

    func markOnboardingAsCompleted() {
        userDefaults.set(true, forKey: onboardingKey)
    }
}
