//
//  User.swift
//  
//
//  Created by Buu Bui on 4/13/16.
//
//

import Foundation
import CoreData
import Firebase
import FirebaseDatabase

class User: NSManagedObject {
  static var currentUId = ""
  static let entityName = "User"
  private var firebase: FIRDatabaseReference?

  var image: UIImage? {
    get {
      guard let imageBase64 = imageBase64 else {
        return nil
      }
      return UIImage.fromBase64(imageBase64)
    }
    set {
      guard let newValue = newValue else {
        imageBase64 = nil
        return
      }
      imageBase64 = newValue.base64
    }
  }

  class func findOrNewByUId(anUid: String, context: NSManagedObjectContext) -> User {
    let request = NSFetchRequest(entityName: User.entityName)
    request.predicate = NSPredicate(format: "uId = %@", anUid)
    do {
      let result = try context.executeFetchRequest(request) as! [User]
      if let user = result.first {
        return user
      }
    } catch {
      print(error)
    }
    return User(dictionary: ["uId": anUid], context: context)
  }

  override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    super.init(entity: entity, insertIntoManagedObjectContext: context)
  }

  convenience init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {

    let entity =  NSEntityDescription.entityForName(User.entityName, inManagedObjectContext: context)!
    self.init(entity: entity, insertIntoManagedObjectContext: context)

    if let theUId = dictionary["uId"] as? String {
      uId = theUId
    }
    if let theName = dictionary["name"] as? String {
      name = theName
    }

    if let theEmail = dictionary["email"] as? String {
      email = theEmail
    }

    if let thePhone = dictionary["phone"] as? String {
      phone = thePhone
    }
  }

  func startObserveFirebaseChange() {
    guard let uId = uId, context = managedObjectContext where firebase == nil else {
      return
    }
    context.performBlockAndWait {
      self.firebase = FirebaseService.shareInstance.observeProfile(uId: uId) { data in
        if let data = data {
          context.performBlock {
            self.updateWithDictionary(data)
          }
        }
      }
    }
  }

  func stopObserveFirebaseChange() {
    guard let firebase = firebase else {
      return
    }
    firebase.removeValueWithCompletionBlock { error, ref in
      guard let error = error else {
        return
      }
      print(error.localizedDescription)
    }
    self.firebase = nil
  }

  func updateWithDictionary(dictionary: [String: AnyObject]) {
    guard let context = managedObjectContext else {
      return
    }
    context.performBlockAndWait {
      if let theUId = dictionary["uId"] as? String {
        self.uId = theUId
      }
      if let theName = dictionary["name"] as? String {
        self.name = theName
      }

      if let theEmail = dictionary["email"] as? String {
        self.email = theEmail
      }

      if let thePhone = dictionary["phone"] as? String {
        self.phone = thePhone
      }

      if let theImageBase64 = dictionary["imageBase64"] as? String {
        self.imageBase64 = theImageBase64
      }
      context.saveRecursively()
      NSNotificationCenter.defaultCenter().postNotificationName(Constant.Notification.didChangeUserObject, object: self)
    }
  }

  func toDictionary() -> [String: AnyObject] {
    var data = [String: AnyObject]()
    if let name = name {
      data["name"] = name
    }
    if let phone = phone {
      data["phone"] = phone
    }
    if let imageBase64 = imageBase64 {
      data["imageBase64"] = imageBase64
    }
    return data
  }

  func updateFirebase(completion: ((error: NSError?) -> Void)? = nil) {
    guard let uId = uId else {
      return
    }
    let data = toDictionary()
    FirebaseService.shareInstance.updateProfile(uId: uId, data: data) { error, firebase in
      completion?(error: error)
    }
  }

  func save() {
    guard let context = managedObjectContext else {
      return
    }
    context.saveRecursively()
  }

}
