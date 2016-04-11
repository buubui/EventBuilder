//
//  FirebaseService.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/5/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import Firebase

class FirebaseService: NSObject {
  static var shareInstance = FirebaseService()
  let ref: Firebase
  private var _authData: FAuthData!

  override init() {
    ref = Firebase(url: Constant.firebaseUrl)
    super.init()
  }

  var authData: FAuthData? {
    return _authData
  }

  func signIn(email email: String, password: String, completion: ( (error:NSError?) -> Void)?) {
    ref.authUser(email, password: password) { [weak self] error, authData in
      self?._authData = authData
      completion?(error: error)
    }
  }

  func signUp(email email: String, password: String, completion: ( (error:NSError?) -> Void)?) {
    ref.createUser(email, password: password) { error in
      completion?(error: error)
    }
  }

  func signOut() {
    ref.unauth()
    _authData = nil
    NSNotificationCenter.defaultCenter().postNotificationName(Constant.Notification.didSignOut, object: self)
  }
}
