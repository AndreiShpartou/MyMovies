//
//  MockLoginView.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 15/04/2025.
//

import UIKit
@testable import MyMovies

// MARK: - MockView
final class MockLoginView: UIView, LoginViewProtocol {
    weak var delegate: LoginViewDelegate?
    
    var didCallSetLoadingIndicator: Bool = false
    var didCallShowError: Bool = false
    var isLoadingIndicatorVisible: Bool?
    var errorMessage: String?
    
    // MARK: - LoginViewProtocol
    func setLoadingIndicator(isVisible: Bool) {
        didCallSetLoadingIndicator = true
        isLoadingIndicatorVisible = isVisible
    }
    
    func showError(with message: String) {
        didCallShowError = true
        errorMessage = message
    }
}

// MARK: - UIViewKeyboardScrollHandlingProtocol
extension MockLoginView: UIViewKeyboardScrollHandlingProtocol {
    func adjustScrollOffset(with offset: CGFloat) {}
    func adjustScrollInset(with inset: CGFloat) {}
}
