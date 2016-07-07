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
import FirebaseStorage

class FirebaseService: NSObject {
  static var shareInstance = FirebaseService()
  let ref: FIRDatabaseReference
  let storageRef: FIRStorageReference

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
    storageRef = FIRStorage.storage().referenceForURL(Constant.Firebase.storageUrl)

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
      let context = CoreDataStackManager.sharedInstance.newPrivateQueueContext()
      context.performBlockAndWait {
        User.updateOrCreateByDictionary(["id": user.uid, "email": email], context: context)
      }
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
      self.createProfile(id: user.uid, name: name, email: email)
    }
  }

  func createProfile(id uId: String, name: String, email: String) {
    let firebase = ref.child(Constant.Firebase.profiles)
    let data = [ uId: ["name" : name, "email": email]]
    firebase.updateChildValues(data)
  }

  func getProfile(id id: String, completion:( (data: [String: AnyObject]?) -> Void)?) {
    let firebase = ref.child(Constant.Firebase.profiles).child(id)
    firebase.observeSingleEventOfType(.Value, withBlock: { snapshot in
      let dict = snapshot.value as? [String: AnyObject]
      completion?(data: dict)
    })
  }

  func observeProfile(id id: String, completion:( (data: [String: AnyObject]?) -> Void)?) -> FIRDatabaseReference {
    let firebase = ref.child(Constant.Firebase.profiles).child(id)
    firebase.observeEventType(.Value, withBlock: { snapshot in
      let dict = snapshot.value as? [String: AnyObject]
      completion?(data: dict)
    })
    return firebase
  }

  func updateProfile(id id: String, data: [String: AnyObject], completion: FirebaseCompletion? = nil) {
    let firebase = ref.child(Constant.Firebase.profiles).child(id)
    updateChildValues(data, firebase: firebase, completion: completion)
  }

  func uploadProfileImage(image: UIImage, userId: String, completion: ((url: NSURL?, error: NSError?) -> Void)?) {
    let fileRef = storageRef.child("users").child("\(userId).jpg")
    guard let data = UIImageJPEGRepresentation(image, 0.8) else {
      return
    }
    fileRef.putData(data, metadata: nil) { metadata, error in
      defer {
        completion?(url: metadata?.downloadURL(), error: error)
      }
    }
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

  func getMyEvents(uId: String, completion: ((keys:[String], receivedDict: [String: AnyObject], receivedId: String) -> Void)?) {
    let firebase = ref.child(Constant.Firebase.profiles).child(uId).child("events")

    retrieveData(firebase) { data in
      guard let dict = data as? [String: AnyObject] else {
        return
      }
      let keys = Array(dict.keys)
      for key in keys {
        self.getEvent(key) { data in
          var newData = data
          newData["id"] = key
          completion?(keys: keys, receivedDict: newData, receivedId: key)
        }
      }
    }
  }

  func getParticipantsOfEventId(id: String, completion: ((keys:[String], receivedDict: [String: AnyObject], receivedId: String) -> Void)?) {
    let firebase = ref.child(Constant.Firebase.events).child(id).child("participants")

    retrieveData(firebase) { data in
      guard let dict = data as? [String: AnyObject] else {
        return
      }
      let keys = Array(dict.keys)
      for key in keys {
        self.getProfile(key) { data in
          var newData = data
          newData["id"] = key
          completion?(keys: keys, receivedDict: newData, receivedId: key)
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

  func getAllEvents(completion: ((keys:[String], receivedDict: [String: AnyObject], receivedId: String) -> Void)?) {
    let firebase = ref.child(Constant.Firebase.events)

    retrieveData(firebase) { data in
      guard let dict = data as? [String: AnyObject] else {
        return
      }
      let keys = Array(dict.keys)
      for key in keys {
        self.getEvent(key) { data in
          var newData = data
          newData["id"] = key
          completion?(keys: keys, receivedDict: newData, receivedId: key)
        }
      }
    }
  }

  func observeEvents(id id: String, completion:( (data: [String: AnyObject]?) -> Void)?) -> FIRDatabaseReference {
    let firebase = ref.child(Constant.Firebase.profiles).child(id)
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
