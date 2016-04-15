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
      if authData != nil {
        self?._authData = authData
        User.currentUId = authData.uid
      }
      completion?(error: error)
    }
  }

  func signUp(email email: String, password: String, name: String, completion: ( (error:NSError?) -> Void)?) {
    ref.createUser(email, password: password) { error, data in
      defer {
        completion?(error: error)
      }
      if data != nil {
        print(data)
        let uId = data["uid"] as! String
        self.createProfile(uId: uId, name: name, email: email)
      }
    }
  }

  func createProfile(uId uId: String, name: String, email: String) {
    let firebase = ref.childByAppendingPath(Constant.Firebase.profiles)
    let data = [ uId: ["name" : name, "email": email]]
    firebase.updateChildValues(data)
  }

  func getProfile(uId uId: String, completion:( (data: [String: AnyObject]?) -> Void)?) {
    let firebase = ref.childByAppendingPath(Constant.Firebase.profiles).childByAppendingPath(uId)
    firebase.observeSingleEventOfType(.Value, withBlock: { snapshot in
      let dict = snapshot.value as? [String: AnyObject]
      completion?(data: dict)
    })
  }

  func observeProfile(uId uId: String, completion:( (data: [String: AnyObject]?) -> Void)?) -> Firebase {
    let firebase = ref.childByAppendingPath(Constant.Firebase.profiles).childByAppendingPath(uId)
    firebase.observeEventType(.Value, withBlock: { snapshot in
      let dict = snapshot.value as? [String: AnyObject]
      completion?(data: dict)
    })
    return firebase
  }

  func updateProfile(uId uId: String, data: [String: AnyObject], completion: ((error: NSError?)-> Void)? = nil) {
    let firebase = ref.childByAppendingPath(Constant.Firebase.profiles).childByAppendingPath(uId)
    updateChildValues(data, firebase: firebase, completion: completion)
  }

  func signOut() {
    ref.unauth()
    _authData = nil
    NSNotificationCenter.defaultCenter().postNotificationName(Constant.Notification.didSignOut, object: self)
  }

  func createEvent(data: [String: AnyObject], completion:((error: NSError?) -> Void)?) {
    let firebase = ref.childByAppendingPath(Constant.Firebase.events).childByAutoId()
    updateChildValues(data, firebase: firebase, completion: completion)
  }

  func updatePlace(placeId placeId: String, data: [String: AnyObject], completion:((error: NSError?) -> Void)?) {
    let firebase = ref.childByAppendingPath(Constant.Firebase.places).childByAppendingPath(placeId)
    updateChildValues(data, firebase: firebase, completion: completion)
  }


  func setValue(value: AnyObject, firebase: Firebase, completion: ((error: NSError?) -> Void)?) {
    firebase.setValue(value) { error, firebase in
      completion?(error: error)
    }
  }

  func updateChildValues(value: [NSObject: AnyObject], firebase: Firebase, completion: ((error: NSError?) -> Void)?) {
    firebase.updateChildValues(value) { error, firebase in
      completion?(error: error)
    }
  }
}
