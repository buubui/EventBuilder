//
//  SignOutTests.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/11/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import KIF

class SignOutTests: BaseIntegrationTest {

  override func beforeEach() {
    super.beforeEach()
    tapSignOutMenuItem()
  }

  func testCancelSignOut() {
    tester().tapViewWithAccessibilityLabel("Cancel")
    tester().waitForAbsenceOfViewWithAccessibilityLabel("Do you really want to sign out?")
  }

  func testSignOutSuccess() {
    tester().tapViewWithAccessibilityLabel("OK")
    tester().waitForViewWithAccessibilityLabel("SignIn - SignInButton")
  }
}

extension BaseIntegrationTest {
  func tapSignOutMenuItem() {
    tester().tapViewWithAccessibilityLabel("LeftMenuBarButton")
    tester().tapViewWithAccessibilityLabel("Sign out")
    tester().waitForViewWithAccessibilityLabel("Do you really want to sign out?")
  }
}
