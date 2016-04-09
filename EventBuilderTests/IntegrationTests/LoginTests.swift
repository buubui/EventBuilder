//
//  LoginTests.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/7/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import KIF

class LoginTests: BaseIntegrationTest {

  func testLoginSucess() {
    loginWithEmail("tester@udacity.com", password: "password")
    tester().waitForViewWithAccessibilityLabel("No Event")
  }

  func testLoginValidationFailure() {
    let requiredError = "This field is required"
    let invalidEmailError = "Must be a valid email address"
    let cases = [
      ("", "", [requiredError]),
      ("tester@abc.com", "", [requiredError]),
      ("", "invalid", [requiredError]),
      ("invalid", "", [invalidEmailError, requiredError]),
     ]
    for (email, password, errors) in cases {
      loginWithEmail(email, password: password)
      for error in errors {
        tester().waitForViewWithAccessibilityLabel(error)
      }
    }
  }

  func testLoginFailure() {
    loginWithEmail("tester@abc.com", password: "invalid")
    tester().waitForViewWithAccessibilityLabel("Invalid email or password")
  }

  private

  func loginWithEmail(email:String, password: String) {
    tester().clearTextFromAndThenEnterText(email, intoViewWithAccessibilityLabel: "Login - EmailTextField")
    tester().clearTextFromAndThenEnterText(password, intoViewWithAccessibilityLabel: "Login - PasswordField")
    tester().tapViewWithAccessibilityLabel("Login - LoginButton")
  }
}
