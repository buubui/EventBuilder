//
//  BaseIntegrationTest.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/7/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import KIF

class BaseIntegrationTest: KIFTestCase {
  override func beforeEach() {
    super.beforeEach()
    returnLoginScreen()
  }

  func returnLoginScreen() {
    let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    let delegate = UIApplication.sharedApplication().delegate!
    delegate.window?!.rootViewController = loginController
  }
}
