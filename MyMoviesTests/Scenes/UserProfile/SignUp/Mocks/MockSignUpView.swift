//
//  MockSignUpView.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 05/04/2025.
//
import UIKit
@testable import MyMovies


// MARK: - MockView
final class MockSignUpView: UIView, SignUpViewProtocol {
    weak var delegate: SignUpViewDelegate?

    var didCallSetLoadingIndicator: Bool = false
    var didCallShowError: Bool = false
    var isLoadingIndicatorVisible: Bool?
    var errorMessage: String?
    
    // MARK: - SignUpViewProtocol
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
extension MockSignUpView: UIViewKeyboardScrollHandlingProtocol {
    func adjustScrollOffset(with offset: CGFloat) {}
    func adjustScrollInset(with inset: CGFloat) {}
}


