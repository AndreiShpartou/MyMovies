//
//  OnboardingViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 20/02/2025.
//

import UIKit

protocol OnboardingViewControllerProtocol: UIViewController {
    var presenter: OnboardingPresenterProtocol { get set }
}

final class OnboardingViewController: UIViewController, OnboardingViewControllerProtocol {
    var presenter: OnboardingPresenterProtocol
    private let onboardingView: OnboardingViewProtocol

    // MARK: - Init
    init(view: OnboardingViewProtocol, presenter: OnboardingPresenterProtocol) {
        self.presenter = presenter
        self.onboardingView = view

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        self.view = onboardingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
        presenter.viewDidLoad()
    }
}

// MARK: - Setup
extension OnboardingViewController {
    private func setupViewController() {
        onboardingView.delegate = self
    }
}

// MARK: - OnboardingViewDelegate
extension OnboardingViewController: OnboardingViewDelegate {
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
