//
//  ExploreScreenTest.swift
//  EventBuilder
//
//  Created by Buu Bui on 7/11/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit

class ExploreScreenTest: BaseIntegrationTest {
  override func beforeEach() {
    super.beforeEach()
    tapExploreMenuItem()
    tester().acknowledgeSystemAlert()
  }

  func testExplore() {
    tester().tapViewWithAccessibilityLabel("Current Test Event")
    tester().tapViewWithAccessibilityLabel("calloutAccessoryButton")
    tester().waitForViewWithAccessibilityLabel("Tester")
    tester().waitForViewWithAccessibilityLabel("Café Royal Hotel")
  }

  func tapExploreMenuItem() {
    tester().tapViewWithAccessibilityLabel("LeftMenuBarButton")
    tester().tapViewWithAccessibilityLabel("Explore")
  }
}
