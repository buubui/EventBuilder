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

  func testElements() {
    tester().waitForViewWithAccessibilityLabel("Profile")
  }
}

extension BaseIntegrationTest {
  func tapProfileMenuItem() {
    tester().tapViewWithAccessibilityLabel("LeftMenuBarButton")
    tester().tapViewWithAccessibilityLabel("Profile")
    tester().waitForViewWithAccessibilityLabel("Profile")
  }
}
