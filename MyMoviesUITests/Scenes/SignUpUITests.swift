//
//  SignUpUITests.swift
//  MyMoviesUITests
//
//  Created by Andrei Shpartou on 10/04/2025.
//

import XCTest

final class SignUpUITests: XCTestCase {
    var app: XCUIApplication!

    enum AccessibilityIdentifier {
        static let tabBar = "tabBar"
        static let profileItem = "profileItem"
        static let profileSettingsSignInButton = "profileSettingsSignInButton"
        static let loginScreenSignUpButton = "loginScreenSignUpButton"
        static let signupFullNameTextField = "signupFullNameTextField"
        static let signupEmailTextField = "signupEmailTextField"
        static let signupPasswordTextField = "signupPasswordTextField"
        static let signupScreenSignupButton = "signupScreenSignupButton"
    }

    enum TestFailureMessage {
        static let profileScreenNotDisplayed = "Profile screen is not displayed."
        static let profileSettingsSignInButtonNotFound = "Profile settings sign in button is not found."
        static let loginScreenNotDisplayed = "Login screen is not displayed."
        static let signupFullNameTextFieldNotFound = "Sign up full name text field is not found."
        static let signupEmailTextFieldNotFound = "Sign up email text field is not found."
        static let signupPasswordTextFieldNotFound = "Sign up password text field is not found."
        static let signupScreenSignupButtonNotFound = "Sign up screen sign up button is not found."
        static let failedToCreateUser = "Failed to create user"
        static let failedToCreateUserAlertNotDisplayed = "Failed to create user alert is not displayed"
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
    func testSignUp_Success() {
        // SignUp with success
        app.launchArguments = ["UITesting"]
        app.launch()
        performSignUp(fullName: "John Test", email: "JohnTest@example.com", password: "Password123")
    }
    
    func testSignUp_Failure() {
        // SignUp with failure
        app.launchArguments = ["UITesting", "MockAuthService_shouldFailOnCreateUser"]
        app.launch()
        performSignUp(fullName: "John Test", email: "JohnTest@example.com", password: "Pass")
        // Check if the error message is displayed
        XCTAssert(app.scrollViews.otherElements.staticTexts[TestFailureMessage.failedToCreateUser].exists, TestFailureMessage.failedToCreateUserAlertNotDisplayed)
    }
}

// MARK: - Private Helper
extension SignUpUITests {
    private func performSignUp(fullName: String, email: String, password: String) {
        // Check if the profile screen is displayed
        XCTAssert(app.tabBars[AccessibilityIdentifier.tabBar].exists, TestFailureMessage.profileScreenNotDisplayed)
        XCTAssert(app.tabBars[AccessibilityIdentifier.tabBar].otherElements[AccessibilityIdentifier.profileItem].exists,TestFailureMessage.profileScreenNotDisplayed)
        app.tabBars[AccessibilityIdentifier.tabBar].buttons.element(boundBy: 3).tap()
        let elementsQuery = app.scrollViews.otherElements
        XCTAssert(elementsQuery.buttons[AccessibilityIdentifier.profileSettingsSignInButton].exists, TestFailureMessage.profileSettingsSignInButtonNotFound)
        // Check if the login screen is displayed
        elementsQuery.buttons[AccessibilityIdentifier.profileSettingsSignInButton].tap()
        XCTAssert(elementsQuery.buttons[AccessibilityIdentifier.loginScreenSignUpButton].exists, TestFailureMessage.loginScreenNotDisplayed)
        // Check if the sign up screen is displayed and contains all the elements
        elementsQuery.buttons[AccessibilityIdentifier.loginScreenSignUpButton].tap()
        XCTAssert(elementsQuery.textFields[AccessibilityIdentifier.signupFullNameTextField].exists, TestFailureMessage.signupFullNameTextFieldNotFound)
        XCTAssert(elementsQuery.textFields[AccessibilityIdentifier.signupEmailTextField].exists, TestFailureMessage.signupEmailTextFieldNotFound)
        XCTAssert(elementsQuery.secureTextFields[AccessibilityIdentifier.signupPasswordTextField].exists, TestFailureMessage.signupPasswordTextFieldNotFound)
        XCTAssert(elementsQuery.buttons[AccessibilityIdentifier.signupScreenSignupButton].exists, TestFailureMessage.signupScreenSignupButtonNotFound)
        // Fill in the sign up form
        elementsQuery.textFields[AccessibilityIdentifier.signupFullNameTextField].tap()
        elementsQuery.textFields[AccessibilityIdentifier.signupFullNameTextField].typeText(fullName)
        elementsQuery.textFields[AccessibilityIdentifier.signupEmailTextField].tap()
        elementsQuery.textFields[AccessibilityIdentifier.signupEmailTextField].typeText(email)
        elementsQuery.secureTextFields[AccessibilityIdentifier.signupPasswordTextField].tap()
        elementsQuery.secureTextFields[AccessibilityIdentifier.signupPasswordTextField].typeText(password)
        // Click on the sign up button
        elementsQuery.buttons[AccessibilityIdentifier.signupScreenSignupButton].tap()
    }
}
