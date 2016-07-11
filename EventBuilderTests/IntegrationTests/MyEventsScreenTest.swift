//
//  MyEventsScreenTest.swift
//  EventBuilder
//
//  Created by Buu Bui on 7/11/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit

class MyEventsScreenTest: BaseIntegrationTest {
  override func beforeEach() {
    super.beforeEach()
  }

  func testMyEvents() {
    for label in ["Current", "Upcoming", "Past"] {
      tester().waitForViewWithAccessibilityLabel(label)
    }
    tester().waitForViewWithAccessibilityLabel("Current Test Event")
    tester().tapViewWithAccessibilityLabel("Upcoming")
    tester().waitForViewWithAccessibilityLabel("Upcoming Test Event")
    tester().tapViewWithAccessibilityLabel("Past")
    tester().waitForViewWithAccessibilityLabel("Past Test Event")
  }

  func testAddEvent() {
    tester().tapViewWithAccessibilityLabel("MyEvents - AddButton")
    tester().clearTextFromAndThenEnterText("food", intoViewWithAccessibilityLabel: "SearchPlace - SearchField")
    tester().tapViewWithAccessibilityLabel("Search")
    tester().acknowledgeSystemAlert()

    tester().tapViewWithAccessibilityLabel("Viet Food")
    tester().tapViewWithAccessibilityLabel("calloutAccessoryButton")

    tester().clearTextFromAndThenEnterText("Super cool event", intoViewWithAccessibilityLabel: "NewEvent - NameTextField")
    tester().tapViewWithAccessibilityLabel("NewEvent - StartDateButton")
    let startDatePicker = tester().waitForViewWithAccessibilityLabel("NewEvent - StartDatePicker") as! UIDatePicker
    startDatePicker.date = NSDate().dateByAddingTimeInterval(2000)
    tester().tapViewWithAccessibilityLabel("NewEvent - StartDateButton")

    tester().tapViewWithAccessibilityLabel("NewEvent - EndDateButton")
    let endDatePicker = tester().waitForViewWithAccessibilityLabel("NewEvent - EndDatePicker") as! UIDatePicker
    endDatePicker.date = NSDate().dateByAddingTimeInterval(5000)
    tester().tapViewWithAccessibilityLabel("NewEvent - EndDateButton")

    tester().clearTextFromAndThenEnterText("Super cool event description", intoViewWithAccessibilityLabel: "NewEvent - DescriptionTextView")
    tester().tapViewWithAccessibilityLabel("Create")
    tester().tapViewWithAccessibilityLabel("Upcoming")
    tester().waitForViewWithAccessibilityLabel("Super cool event")
  }
}
