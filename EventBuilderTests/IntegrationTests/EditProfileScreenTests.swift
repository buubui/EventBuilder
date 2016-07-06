//
//  EditProfileScreenTests.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/15/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit

class EditProfileScreenTests: BaseIntegrationTest {
  override func beforeEach() {
    super.beforeEach()
    gotoEditProfileScreen()
  }

  func testEditProfile() {
    let newName = "New Tester Name"
    let newPhone = "124 124 124"

    tester().clearTextFromAndThenEnterText(newName, intoViewWithAccessibilityLabel: "EditProfile - NameField")
    tester().clearTextFromAndThenEnterText(newPhone, intoViewWithAccessibilityLabel: "EditProfile - PhoneField")
    tester().tapViewWithAccessibilityLabel("EditProfile - ChangeProfilePictureButton")
    tester().tapViewWithAccessibilityLabel("Gallery")
    tester().acknowledgeSystemAlert()
    tester().tapScreenAtPoint(CGPoint(x: 35, y: 110))
    tester().tapViewWithAccessibilityLabel("confirmButton")
    tester().tapViewWithAccessibilityLabel("Save")
    tester().waitForTimeInterval(20)
    tester().waitForViewWithAccessibilityLabel(newName)
    tester().waitForViewWithAccessibilityLabel(newPhone)
  }
}

extension BaseIntegrationTest {
  func gotoEditProfileScreen() {
    tapProfileMenuItem()
    tester().tapViewWithAccessibilityLabel("Profile - EditButton")
  }
}
