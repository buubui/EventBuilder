//
//  SideMenuTests.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/11/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import KIF

class SideMenuTests: BaseIntegrationTest {

  override func beforeEach() {
    super.beforeEach()
    tester().tapViewWithAccessibilityLabel("LeftMenuBarButton")
  }

  func testElements() {
    for label in ["My Events", "Explore", "Profile", "Sign out"] {
      tester().waitForViewWithAccessibilityLabel(label)
    }
  }
}
