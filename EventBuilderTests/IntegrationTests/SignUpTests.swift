//
//  SignUpTests.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/9/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
@testable import EventBuilder

class SignUpTests: BaseIntegrationTest {

  override var shouldSignIn: Bool {
    return false
  }

  override func beforeEach() {
    super.beforeEach()
    tester().tapViewWithAccessibilityLabel("SignIn - SignUpButton")
  }
  func testSignUpSucess() {

    let email = faker.internet.email()
    let password = faker.internet.password()
    signUpWithEmail(email, password: password)
    tester().waitForViewWithAccessibilityLabel("Sign up successfully, please sign in")
    signInWithEmail(email, password: password)
    tester().waitForViewWithAccessibilityLabel("No Event")
    FirebaseService.shareInstance.ref.removeUser(email, password: password, withCompletionBlock: nil)
    NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 5))
  }

  func testSignUpValidationFailure() {
    let requiredError = "This field is required"
    let invalidEmailError = "Must be a valid email address"
    let cases = [
      ("", "", [requiredError]),
      (faker.internet.email(), "", [requiredError]),
      ("", faker.internet.password(), [requiredError]),
      (faker.internet.username(), "", [invalidEmailError, requiredError]),
      ]
    for (email, password, errors) in cases {
      signUpWithEmail(email, password: password)
      for error in errors {
        tester().waitForViewWithAccessibilityLabel(error)
      }
    }
  }

  func testSignUpFailure() {
    signUpWithEmail(TestConstant.email, password: faker.internet.password())
    tester().waitForTappableViewWithAccessibilityLabel("This email address is already in use")
  }

  private

  func signUpWithEmail(email:String, password: String) {
    tester().clearTextFromAndThenEnterText(email, intoViewWithAccessibilityLabel: "SignUp - EmailTextField")
    tester().clearTextFromAndThenEnterText(password, intoViewWithAccessibilityLabel: "SignUp - PasswordField")
    tester().tapViewWithAccessibilityLabel("SignUp - SignUpButton")
  }

}
