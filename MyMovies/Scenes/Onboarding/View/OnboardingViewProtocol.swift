//
//  OnboardingViewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 20/02/2025.
//

import UIKit

protocol OnboardingViewProtocol: UIView {
    var delegate: OnboardingViewDelegate? { get set }

    func configurePages(_ pages: [OnboardingPageViewModelProtocol])
    func showPage(at index: Int)
    func showError()
}

protocol OnboardingViewDelegate: AnyObject {
    func didTapSkip()
    func didTapNext()
    func didTapGetStarted()
}
