//
//  OnboardingInteractorProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 20/02/2025.
//

import Foundation

protocol OnboardingInteractorProtocol: AnyObject {
    var presenter: OnboardingInteractorOutputProtocol? { get set }

    func markOnboardingAsCompleted()
}

protocol OnboardingInteractorOutputProtocol: AnyObject {
    //
}
