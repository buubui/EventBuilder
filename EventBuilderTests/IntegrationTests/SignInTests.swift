//
//  SignInTests.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/7/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import KIF

class SignInTests: BaseIntegrationTest {

  override var shouldSignIn: Bool {
    return false
  }

  func testSignInSucess() {
    signInWithValidCredential()
  }

  func testSignInValidationFailure() {
    let requiredError = "This field is required"
    let invalidEmailError = "Must be a valid email address"
    let cases = [
      ("", "", [requiredError]),
      (faker.internet.email(), "", [requiredError]),
      ("", faker.internet.password(), [requiredError]),
      (faker.internet.username(), "", [invalidEmailError, requiredError]),
     ]
    for (email, password, errors) in cases {
      signInWithEmail(email, password: password)
      for error in errors {
        tester().waitForViewWithAccessibilityLabel(error)
      }
    }
  }

  func testSignInFailure() {
    signInWithEmail(faker.internet.email(), password: faker.internet.password())
    tester().waitForViewWithAccessibilityLabel("There is no user record corresponding to this identifier. The user may have been deleted.")
  }
}

extension BaseIntegrationTest {

  func signInWithEmail(email:String, password: String) {
    tester().clearTextFromAndThenEnterText(email, intoViewWithAccessibilityLabel: "SignIn - EmailTextField")
    tester().clearTextFromAndThenEnterText(password, intoViewWithAccessibilityLabel: "SignIn - PasswordField")
    tester().tapViewWithAccessibilityLabel("SignIn - SignInButton")
  }
}
