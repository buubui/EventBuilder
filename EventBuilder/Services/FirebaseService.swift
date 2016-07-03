//
//  FirebaseService.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/5/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FirebaseService: NSObject {
  static var shareInstance = FirebaseService()
  let ref: FIRDatabaseReference

  typealias FirebaseCompletion = (error: NSError?, firebase: FIRDatabaseReference) -> Void

  override init() {
    if Helper.isTestMode() {
      guard let path = NSBundle.mainBundle().pathForResource("GoogleService-Info-Test", ofType: "plist"), dict = NSDictionary(contentsOfFile: path) else {
        fatalError("Cannot load GoogleService-Info")
      }
      let options = FIROptions(
        googleAppID: dict["GOOGLE_APP_ID"] as! String,
        bundleID: dict["BUNDLE_ID"] as! String,
        GCMSenderID: dict["GCM_SENDER_ID"] as! String,
        APIKey: dict["API_KEY"] as! String,
        clientID: dict["CLIENT_ID"] as! String,
        trackingID: "",
        androidClientID: "",
        databaseURL: Constant.Firebase.baseTestUrl,
        storageBucket: "",
        deepLinkURLScheme: ""
      )
      FIRApp.configureWithOptions(options)
    } else {
      FIRApp.configure()
    }
    ref = FIRDatabase.database().reference()
    super.init()
  }

  func signIn(email email: String, password: String, completion: ( (error:NSError?) -> Void)?) {
    FIRAuth.auth()?.signInWithEmail(email, password: password) {user, error in
      defer {
        completion?(error: error)
      }
      guard let user = user else {
        return
      }
      User.currentUId = user.uid
    }
  }

  func signUp(email email: String, password: String, name: String, completion: ( (error:NSError?) -> Void)?) {
    FIRAuth.auth()?.createUserWithEmail(email, password: password) { user, error in
      defer {
        completion?(error: error)
      }
      guard let user = user else {
        return
      }
      self.createProfile(uId: user.uid, name: name, email: email)
    }
  }

  func createProfile(uId uId: String, name: String, email: String) {
    let firebase = ref.child(Constant.Firebase.profiles)
    let data = [ uId: ["name" : name, "email": email]]
    firebase.updateChildValues(data)
  }

  func getProfile(uId uId: String, completion:( (data: [String: AnyObject]?) -> Void)?) {
    let firebase = ref.child(Constant.Firebase.profiles).child(uId)
    firebase.observeSingleEventOfType(.Value, withBlock: { snapshot in
      let dict = snapshot.value as? [String: AnyObject]
      completion?(data: dict)
    })
  }

  func observeProfile(uId uId: String, completion:( (data: [String: AnyObject]?) -> Void)?) -> FIRDatabaseReference {
    let firebase = ref.child(Constant.Firebase.profiles).child(uId)
    firebase.observeEventType(.Value, withBlock: { snapshot in
      let dict = snapshot.value as? [String: AnyObject]
      completion?(data: dict)
    })
    return firebase
  }

  func updateProfile(uId uId: String, data: [String: AnyObject], completion: FirebaseCompletion? = nil) {
    let firebase = ref.child(Constant.Firebase.profiles).child(uId)
    updateChildValues(data, firebase: firebase, completion: completion)
  }

  func signOut() {
    try! FIRAuth.auth()?.signOut()
    NSNotificationCenter.defaultCenter().postNotificationName(Constant.Notification.didSignOut, object: self)
  }

  func createEvent(data: [String: AnyObject], completion:FirebaseCompletion?) {
    let firebase = ref.child(Constant.Firebase.events).childByAutoId()
    updateChildValues(data, firebase: firebase) { error, firebase in
      if let participants_dict = data["participants"] as? [String: Bool] {
        participants_dict.keys.forEach { uId in
          let firebase = self.ref.child(Constant.Firebase.profiles).child(uId).child("events/\(firebase.key)")
          self.setValue(true, firebase: firebase, completion: nil)
        }
      }
      completion?(error: error, firebase: firebase)
    }
  }

  func isAttendEvent(eventId: String, userId: String, completion: ((value: Bool)-> Void)? ) {
    let firebase = ref.child(Constant.Firebase.events).child(eventId).child(Constant.Firebase.participants).child(userId)
    retrieveData(firebase) { data in
      guard let value = data as? Bool else {
        completion?(value: false)
        return
      }
      completion?(value: value)
    }
  }

  func attendEvent(eventId: String, userId: String, completion: FirebaseCompletion? ) {
    let firebase = ref.child(Constant.Firebase.events).child(eventId).child(Constant.Firebase.participants).child(userId)
    setValue(true, firebase: firebase, completion: completion)
  }

  func updatePlace(placeId placeId: String, data: [String: AnyObject], completion:FirebaseCompletion?) {
    let firebase = ref.child(Constant.Firebase.places).child(placeId)
    updateChildValues(data, firebase: firebase, completion: completion)
  }

  func getEvent(key: String, completion: ((data: [String: AnyObject]) -> Void)?) {
    let firebase = ref.child(Constant.Firebase.events).child(key)
    retrieveData(firebase) { data in
      guard let dict = data as? [String: AnyObject] else {
        return
      }
      completion?(data: dict)
    }
  }

  func getMyEvents(uId: String, completion: ((keys:[String], receivedEventDict: [String: AnyObject], receivedEventId: String) -> Void)?) {
    let firebase = ref.child(Constant.Firebase.profiles).child(uId).child("events")

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
    let firebase = ref.child(Constant.Firebase.events).child(uId).child("participants")

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
    let firebase = ref.child(Constant.Firebase.profiles).child(key)
    retrieveData(firebase) { data in
      guard let dict = data as? [String: AnyObject] else {
        return
      }
      completion?(data: dict)
    }
  }

  func getAllEvents(completion: ((keys:[String], receivedDict: [String: AnyObject], receivedUid: String) -> Void)?) {
    let firebase = ref.child(Constant.Firebase.events)

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

  func observeEvents(uId uId: String, completion:( (data: [String: AnyObject]?) -> Void)?) -> FIRDatabaseReference {
    let firebase = ref.child(Constant.Firebase.profiles).child(uId)
    firebase.observeEventType(.ChildAdded, withBlock: { snapshot in
      let dict = snapshot.value as? [String: AnyObject]
      completion?(data: dict)
    })
    return firebase
  }

  func retrieveData(firebase: FIRDatabaseReference, completion: ((data: AnyObject) -> Void)?) {
    firebase.observeSingleEventOfType(.Value, withBlock: { snapshot in
      completion?(data: snapshot.value!)
    })
  }

  func setValue(value: AnyObject, firebase: FIRDatabaseReference, completion: FirebaseCompletion?) {
    firebase.setValue(value) { error, firebase in
      completion?(error: error, firebase: firebase)
    }
  }

  func updateChildValues(value: [NSObject: AnyObject], firebase: FIRDatabaseReference, completion: FirebaseCompletion?) {
    firebase.updateChildValues(value) { error, firebase in
      completion?(error: error, firebase: firebase)
    }
  }
}
