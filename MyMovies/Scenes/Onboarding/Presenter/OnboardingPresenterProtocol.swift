//
//  OnboardingPresenterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 20/02/2025.
//

import Foundation

protocol OnboardingPresenterProtocol: AnyObject {
    var view: OnboardingViewProtocol? { get set }
    var interactor: OnboardingInteractorProtocol { get set }
    var router: OnboardingRouterProtocol { get set }

    func viewDidLoad()
    func didTapSkip()
    func didTapNext()
    func didTapGetStarted()
}
