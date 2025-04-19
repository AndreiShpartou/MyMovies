//
//  MockLoginPresenter.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 15/04/2025.
//

import Foundation
@testable import MyMovies

final class MockLoginPresenter: LoginInteractorOutputProtocol {
    var didCallDidSignInSuccessfullyCallBack: (() -> Void)?
    var didCallDidFailToSignInCallBack: (() -> Void)?
    
    func didSignInSuccessfully() {
        didCallDidSignInSuccessfullyCallBack?()
    }
    
    func didFailToSignIn(with error: Error) {
        didCallDidFailToSignInCallBack?()
    }
}
