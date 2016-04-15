//
//  BaseIntegrationTest.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/7/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import KIF
import Fakery
@testable import EventBuilder

class BaseIntegrationTest: KIFTestCase {
  let faker = Faker()
  var shouldSignIn: Bool {
    return true
  }

  override func beforeAll() {
    super.beforeAll()
    initFirebaseProfiles()
  }

  override func beforeEach() {
    super.beforeEach()
    returnLoginScreen()
    if shouldSignIn {
      signInWithValidCredential()
    }
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

  func initFirebaseProfiles() {
    let firebase = FirebaseService.shareInstance.ref.childByAppendingPath("profiles")
    firebase.setValue(TestConstant.defaultFireBaseProfiles) { (error, firebase) in

    }
  }
}
