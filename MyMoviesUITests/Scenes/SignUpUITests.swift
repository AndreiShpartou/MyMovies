//
//  SignUpUITests.swift
//  MyMoviesUITests
//
//  Created by Andrei Shpartou on 10/04/2025.
//

import XCTest

final class SignUpUITests: XCTestCase {
    var app: XCUIApplication!

    struct AccessibilityIdentifier {
        static let loginScreen = "loginScreen"
        static let emailTextField = "txtEmail"
        static let passwordTextField = "txtPassword"
        static let loginButton = "btnLogin"
        static let welcomeScreen = "welcomeScreen"
    }

    struct TestFailureMessage {
        static let loginScreenNotDisplayed = "Login screen is not displayed."
        static let emailTextFieldNotFound = "Email text field is not found."
        static let passwordTextFieldNotFound = "Password text field is not found."
        static let loginButtonNotFound = "Login button is not found."
        static let loginNotSuccessful = "Login is not successful. Welcome screen is not displayed."
    }
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("UITesting")
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSignUp_Success() {
                        
    }
}
