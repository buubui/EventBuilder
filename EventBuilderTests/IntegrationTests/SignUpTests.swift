//
//  SignUpTests.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/9/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import Firebase
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
    let name = faker.name.name()
    signUpWithEmail(email, password: password, name: name)
    tester().waitForViewWithAccessibilityLabel("Sign up successfully, please sign in")
    signInWithEmail(email, password: password)
    tester().waitForViewWithAccessibilityLabel("No Event")
    FIRAuth.auth()?.currentUser?.deleteWithCompletion() { error in

    }
    NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 5))
  }

  func testSignUpValidationFailure() {
    let requiredError = "This field is required"
    let invalidEmailError = "Must be a valid email address"
    let cases = [
      ("", "", "", [requiredError]),
      (faker.internet.email(), "", "", [requiredError]),
      ("", faker.internet.password(), faker.name.name(), [requiredError]),
      (faker.internet.username(), "", faker.name.name(), [invalidEmailError, requiredError]),
      ]
    for (email, password, name, errors) in cases {
      signUpWithEmail(email, password: password, name: name)
      for error in errors {
        tester().waitForViewWithAccessibilityLabel(error)
      }
    }
  }

  func testSignUpFailure() {
    signUpWithEmail(TestConstant.email, password: faker.internet.password(), name: faker.name.name())
    tester().waitForTappableViewWithAccessibilityLabel("The email address is already in use by another account.")
  }

  private

  func signUpWithEmail(email:String, password: String, name: String) {
    tester().clearTextFromAndThenEnterText(email, intoViewWithAccessibilityLabel: "SignUp - EmailTextField")
    tester().clearTextFromAndThenEnterText(password, intoViewWithAccessibilityLabel: "SignUp - PasswordField")
    tester().clearTextFromAndThenEnterText(name, intoViewWithAccessibilityLabel: "SignUp - NameField")
    tester().tapViewWithAccessibilityLabel("SignUp - SignUpButton")
  }

}
