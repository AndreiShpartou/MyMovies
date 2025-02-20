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

    private var currentPage: Int = 0
    private var pages: [OnboardingPageViewModelProtocol] = []

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
        interactor.fetchOnboardingData()
    }

    func didTapSkip() {
        // Mark completed and go to main flow
        interactor.markOnboardingAsCompleted()
        router.navigateToMainFlow()
    }

    func didTapNext() {
        currentPage += 1
        if currentPage < pages.count {
            view?.showPage(at: currentPage)
        } else {
            // End
            didTapGetStarted()
        }
    }

    func didTapGetStarted() {
        // Mark completed and go to main flow
        interactor.markOnboardingAsCompleted()
        router.navigateToMainFlow()
    }
}

// MARK: - OnboardingInteractorOutputProtocol
extension OnboardingPresenter: OnboardingInteractorOutputProtocol {
    func didFetchOnboardingData() {
        pages = [
            OnboardingPageViewModel(
                title: "Welcome!",
                description: "Discover amazing movies and series from around the world.",
                lottieFileName: "onboardingAnimation1"
            ),
            OnboardingPageViewModel(
                title: "Track Favorites",
                description: "Easily keep track of your favorite titles.",
                lottieFileName: "onboardingAnimation2"
            ),
            OnboardingPageViewModel(
                title: "Stay Updated",
                description: "Get the latest upcoming releases and never miss out.",
                lottieFileName: "onboardingAnimation3"
            )
        ]

        view?.configurePages(pages)
    }
}
