//
//  EventDetailScreenTest.swift
//  EventBuilder
//
//  Created by Buu Bui on 7/11/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit

class EventDetailScreenTest: BaseIntegrationTest {
  override func beforeEach() {
    super.beforeEach()
    tester().tapViewWithAccessibilityLabel("Current Test Event")
  }
  func testEventDetails() {
    tester().waitForViewWithAccessibilityLabel("Tester")
    tester().waitForViewWithAccessibilityLabel("Café Royal Hotel")
    tester().waitForViewWithAccessibilityLabel("68 Regent St")
    tester().waitForViewWithAccessibilityLabel("Current Event Description")
    tester().waitForViewWithAccessibilityLabel("Jul 11 at 12:56 AM to Aug 28 at 12:55 AM")
    tester().waitForViewWithAccessibilityLabel("Jul 11 - Aug 28")
  }

  func testParticipantsScreen() {
    tester().tapViewWithAccessibilityLabel("Participants")
    tester().waitForViewWithAccessibilityLabel("Tester")
    tester().waitForViewWithAccessibilityLabel("Tester 2")
  }
}
