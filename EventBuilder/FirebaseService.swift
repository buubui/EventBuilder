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
  private var _authData: FAuthData!
  var authData: FAuthData? {
    return _authData
  }
  func signIn(email email: String, password: String, completion: ( (error:NSError?) -> Void)?) {
    let ref = Firebase(url: Constant.firebaseUrl)
    ref.authUser(email, password: password) { [weak self] error, authData in
      self?._authData = authData
      completion?(error: error)
    }
  }
}
