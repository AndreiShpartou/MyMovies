//
//  OnboardingPresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 20/02/2025.
//

final class OnboardingPresenter: OnboardingPresenterProtocol {
    weak var view: OnboardingViewProtocol?
    var interactor: OnboardingInteractorProtocol
    var router: OnboardingRouterProtocol

    // MARK: - Init
    init(
        view: OnboardingViewProtocol? = nil,
        interactor: OnboardingInteractorProtocol,
        router: OnboardingRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    // MARK: - Public
    func viewDidLoad() {
        //
    }

    func didTapSkip() {
        //
    }

    func didTapNext() {
        //
    }

    func didTapGetStarted() {
        //
    }
}

// MARK: - OnboardingInteractorOutputProtocol
extension OnboardingPresenter: OnboardingInteractorOutputProtocol {
    func didFetchOnboardingData() {
        //
    }
}
