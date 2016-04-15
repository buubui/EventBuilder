//
//  ProfileScreenTests.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/11/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import KIF

class ProfileScreenTests: BaseIntegrationTest {
  override func beforeEach() {
    super.beforeEach()
    tapProfileMenuItem()
  }

  func testProfile() {
    tester().waitForViewWithAccessibilityLabel("Tester")
    tester().waitForViewWithAccessibilityLabel("tester@udacity.com")
    tester().waitForViewWithAccessibilityLabel("123 123 123")
  }
}

extension BaseIntegrationTest {
  func tapProfileMenuItem() {
    tester().tapViewWithAccessibilityLabel("LeftMenuBarButton")
    tester().tapViewWithAccessibilityLabel("Profile")
    tester().waitForViewWithAccessibilityLabel("Profile")
  }
}
