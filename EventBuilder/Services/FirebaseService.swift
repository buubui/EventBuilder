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

  typealias FirebaseCompletion = (error: NSError?, firebase: Firebase) -> Void

  override init() {
    ref = Firebase(url: Constant.Firebase.baseUrl)
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

  func updateProfile(uId uId: String, data: [String: AnyObject], completion: FirebaseCompletion? = nil) {
    let firebase = ref.childByAppendingPath(Constant.Firebase.profiles).childByAppendingPath(uId)
    updateChildValues(data, firebase: firebase, completion: completion)
  }

  func signOut() {
    ref.unauth()
    _authData = nil
    NSNotificationCenter.defaultCenter().postNotificationName(Constant.Notification.didSignOut, object: self)
  }

  func createEvent(data: [String: AnyObject], completion:FirebaseCompletion?) {
    let firebase = ref.childByAppendingPath(Constant.Firebase.events).childByAutoId()
    updateChildValues(data, firebase: firebase) { error, firebase in
      if let participants_dict = data["participants"] as? [String: Bool] {
        participants_dict.keys.forEach { uId in
          let firebase = self.ref.childByAppendingPath(Constant.Firebase.profiles).childByAppendingPath(uId).childByAppendingPath("events/\(firebase.key)")
          self.setValue(true, firebase: firebase, completion: nil)
        }
      }
      completion?(error: error, firebase: firebase)
    }
  }

  func isAttendEvent(eventId: String, userId: String, completion: ((value: Bool)-> Void)? ) {
    let firebase = ref.childByAppendingPath(Constant.Firebase.events).childByAppendingPath(eventId).childByAppendingPath(Constant.Firebase.participants).childByAppendingPath(userId)
    retrieveData(firebase) { data in
      guard let value = data as? Bool else {
        completion?(value: false)
        return
      }
      completion?(value: value)
    }
  }

  func attendEvent(eventId: String, userId: String, completion: FirebaseCompletion? ) {
    let firebase = ref.childByAppendingPath(Constant.Firebase.events).childByAppendingPath(eventId).childByAppendingPath(Constant.Firebase.participants).childByAppendingPath(userId)
    setValue(true, firebase: firebase, completion: completion)
  }

  func updatePlace(placeId placeId: String, data: [String: AnyObject], completion:FirebaseCompletion?) {
    let firebase = ref.childByAppendingPath(Constant.Firebase.places).childByAppendingPath(placeId)
    updateChildValues(data, firebase: firebase, completion: completion)
  }

  func getEvent(key: String, completion: ((data: [String: AnyObject]) -> Void)?) {
    let firebase = ref.childByAppendingPath(Constant.Firebase.events).childByAppendingPath(key)
    retrieveData(firebase) { data in
      guard let dict = data as? [String: AnyObject] else {
        return
      }
      completion?(data: dict)
    }
  }

  func getMyEvents(uId: String, completion: ((keys:[String], receivedEventDict: [String: AnyObject], receivedEventId: String) -> Void)?) {
    let firebase = ref.childByAppendingPath(Constant.Firebase.profiles).childByAppendingPath(uId).childByAppendingPath("events")

    retrieveData(firebase) { data in
      guard let dict = data as? [String: AnyObject] else {
        return
      }
      let keys = Array(dict.keys)
      for key in keys {
        self.getEvent(key) { data in
          var newData = data
          newData["uId"] = key
          completion?(keys: keys, receivedEventDict: newData, receivedEventId: key)
        }
      }
    }
  }

  func getParticipantsOfEventId(uId: String, completion: ((keys:[String], receivedDict: [String: AnyObject], receivedUid: String) -> Void)?) {
    let firebase = ref.childByAppendingPath(Constant.Firebase.events).childByAppendingPath(uId).childByAppendingPath("participants")

    retrieveData(firebase) { data in
      guard let dict = data as? [String: AnyObject] else {
        return
      }
      let keys = Array(dict.keys)
      for key in keys {
        self.getProfile(key) { data in
          var newData = data
          newData["uId"] = key
          completion?(keys: keys, receivedDict: newData, receivedUid: key)
        }
      }
    }
  }

  func getProfile(key: String, completion: ((data: [String: AnyObject]) -> Void)?) {
    let firebase = ref.childByAppendingPath(Constant.Firebase.profiles).childByAppendingPath(key)
    retrieveData(firebase) { data in
      guard let dict = data as? [String: AnyObject] else {
        return
      }
      completion?(data: dict)
    }
  }

  func getAllEvents(completion: ((keys:[String], receivedDict: [String: AnyObject], receivedUid: String) -> Void)?) {
    let firebase = ref.childByAppendingPath(Constant.Firebase.events)

    retrieveData(firebase) { data in
      guard let dict = data as? [String: AnyObject] else {
        return
      }
      let keys = Array(dict.keys)
      for key in keys {
        self.getEvent(key) { data in
          var newData = data
          newData["uId"] = key
          completion?(keys: keys, receivedDict: newData, receivedUid: key)
        }
      }
    }
  }

  func observeEvents(uId uId: String, completion:( (data: [String: AnyObject]?) -> Void)?) -> Firebase {
    let firebase = ref.childByAppendingPath(Constant.Firebase.profiles).childByAppendingPath(uId)
    firebase.observeEventType(.ChildAdded, withBlock: { snapshot in
      let dict = snapshot.value as? [String: AnyObject]
      completion?(data: dict)
    })
    return firebase
  }

  func retrieveData(firebase: Firebase, completion: ((data: AnyObject) -> Void)?) {
    firebase.observeSingleEventOfType(.Value, withBlock: { snapshot in
      completion?(data: snapshot.value)
    })
  }

  func setValue(value: AnyObject, firebase: Firebase, completion: FirebaseCompletion?) {
    firebase.setValue(value) { error, firebase in
      completion?(error: error, firebase: firebase)
    }
  }

  func updateChildValues(value: [NSObject: AnyObject], firebase: Firebase, completion: FirebaseCompletion?) {
    firebase.updateChildValues(value) { error, firebase in
      completion?(error: error, firebase: firebase)
    }
  }
}
