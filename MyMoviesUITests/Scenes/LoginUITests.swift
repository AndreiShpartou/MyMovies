//
//  LoginUITests.swift
//  MyMoviesUITests
//
//  Created by Andrei Shpartou on 15/04/2025.
//

import XCTest

final class LoginUITests: XCTestCase {
    var app: XCUIApplication!

    enum AccessibilityIdentifier {
        static let tabBar = "tabBar"
        static let profileItem = "profileItem"
        static let profileSettingsSignInButton = "profileSettingsSignInButton"
        static let loginEmailTextField = "loginEmailTextField"
        static let loginPasswordTextField = "loginPasswordTextField"
        static let loginScreenSignInButton = "loginScreenSignInButton"
        static let loginScreenSignUpButton = "loginScreenSignUpButton"
    }

    enum TestFailureMessage {
        static let profileScreenNotDisplayed = "Profile screen is not displayed."
        static let profileSettingsSignInButtonNotFound = "Profile settings sign in button is not found."
        static let loginScreenNotDisplayed = "Login screen is not displayed."
        
        static let failedToSignIn = "Failed to sign in"
        static let failedToSignInAlertNotDisplayed = "Failed to sign in alert is not displayed"
    }
    
    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - TestCases
    func testLogin_Success() {
        // SignIn with success
        app.launchArguments = ["UITesting"]
        app.launch()
        performLogin(email: "JohnTest@example.com", password: "Password123")
    }
    
    func testLogin_Failure() {
        // SignIn with failure
        app.launchArguments = ["UITesting", "MockAuthService_shouldFailOnSignIn"]
        app.launch()
        performLogin(email: "JohnTest@example.com", password: "Pass")
        // Check if the error message is displayed
        XCTAssert(app.scrollViews.otherElements.staticTexts[TestFailureMessage.failedToSignIn].exists, TestFailureMessage.failedToSignInAlertNotDisplayed)
    }
}

// MARK: - Private Helpers
extension LoginUITests {
    private func performLogin(email: String, password: String) {
        // Check if the profile screen is displayed
        XCTAssert(app.tabBars[AccessibilityIdentifier.tabBar].exists, TestFailureMessage.profileScreenNotDisplayed)
        XCTAssert(app.tabBars[AccessibilityIdentifier.tabBar].otherElements[AccessibilityIdentifier.profileItem].exists,TestFailureMessage.profileScreenNotDisplayed)
        app.tabBars[AccessibilityIdentifier.tabBar].buttons.element(boundBy: 3).tap()
        let elementsQuery = app.scrollViews.otherElements
        XCTAssert(elementsQuery.buttons[AccessibilityIdentifier.profileSettingsSignInButton].exists, TestFailureMessage.profileSettingsSignInButtonNotFound)
        // Check if the login screen is displayed
        elementsQuery.buttons[AccessibilityIdentifier.profileSettingsSignInButton].tap()
        XCTAssert(elementsQuery.textFields[AccessibilityIdentifier.loginEmailTextField].exists, TestFailureMessage.loginScreenNotDisplayed)
        XCTAssert(elementsQuery.secureTextFields[AccessibilityIdentifier.loginPasswordTextField].exists, TestFailureMessage.loginScreenNotDisplayed)
        XCTAssert(elementsQuery.buttons[AccessibilityIdentifier.loginScreenSignInButton].exists, TestFailureMessage.loginScreenNotDisplayed)
        XCTAssert(elementsQuery.buttons[AccessibilityIdentifier.loginScreenSignUpButton].exists, TestFailureMessage.loginScreenNotDisplayed)
        // Fill in the SignIn form
        elementsQuery.textFields[AccessibilityIdentifier.loginEmailTextField].tap()
        elementsQuery.textFields[AccessibilityIdentifier.loginEmailTextField].typeText(email)
        elementsQuery.secureTextFields[AccessibilityIdentifier.loginPasswordTextField].tap()
        elementsQuery.secureTextFields[AccessibilityIdentifier.loginPasswordTextField].typeText(password)
        // Click on the sign in button
        elementsQuery.buttons[AccessibilityIdentifier.loginScreenSignInButton].tap()
    }
}
