//
//  BaseIntegrationTest.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/7/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import KIF
import Fakery

class BaseIntegrationTest: KIFTestCase {
  let faker = Faker()
  override func beforeEach() {
    super.beforeEach()
    returnLoginScreen()
  }

  func returnLoginScreen() {
    let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    let delegate = UIApplication.sharedApplication().delegate!
    delegate.window?!.rootViewController = loginController
  }

  func signInWithValidCredential() {
    signInWithEmail(TestConstant.email, password: TestConstant.password)
    tester().waitForViewWithAccessibilityLabel("My Events")
  }
}
