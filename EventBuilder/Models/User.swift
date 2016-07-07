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
  private var imageChanged = false

  var image: UIImage? {
    didSet {
      imageChanged = true
    }
  }

  class func currentUser(context: NSManagedObjectContext = CoreDataStackManager.sharedInstance.mainQueueContext) -> User? {
    let request = NSFetchRequest(entityName: User.entityName)
    request.predicate = NSPredicate(format: "id = %@", currentUId)

    do {
      let result = try context.executeFetchRequest(request) as! [User]
      if let user = result.first {
        return user
      }
    } catch {
      print(error)
    }
    return nil
  }

  class func findOrNewByUId(anId: String, context: NSManagedObjectContext) -> User {
    let request = NSFetchRequest(entityName: User.entityName)
    request.predicate = NSPredicate(format: "id = %@", anId)
    do {
      let result = try context.executeFetchRequest(request) as! [User]
      if let user = result.first {
        return user
      }
    } catch {
      print(error)
    }
    return User(dictionary: ["id": anId], context: context)
  }

  class func updateOrCreateByDictionary(dictionary: [String: AnyObject], context: NSManagedObjectContext) -> User? {
    guard let anId = dictionary["id"] as? String else {
      return nil
    }
    let request = NSFetchRequest(entityName: User.entityName)
    request.predicate = NSPredicate(format: "id = %@", anId)
    do {
      let result = try context.executeFetchRequest(request) as! [User]
      if let user = result.first {
        user.update(dictionary)
        return user
      }
    } catch {
      print(error)
    }
    return User(dictionary: dictionary, context: context)
  }

  override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    super.init(entity: entity, insertIntoManagedObjectContext: context)
  }

  convenience init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {

    let entity =  NSEntityDescription.entityForName(User.entityName, inManagedObjectContext: context)!
    self.init(entity: entity, insertIntoManagedObjectContext: context)

    update(dictionary)
  }

  func update(dictionary: [String: AnyObject]) {
    if let theId = dictionary["id"] as? String {
      id = theId
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
    save()
  }

  func getMyEvents(completion:((keys:[String], receivedEvent: Event) -> Void)?) {
    guard let id = id, context = managedObjectContext else {
      return
    }
    FirebaseService.shareInstance.getMyEvents(id) { keys, receivedDict, receivedId in

      context.performBlockAndWait {
        guard let event = Event.updateOrCreateByDictionary(receivedDict, context: context) else {
          return
        }
        completion?(keys: keys, receivedEvent: event)
      }
    }
  }


  func startObserveFirebaseChange() {
    guard let id = id, context = managedObjectContext where firebase == nil else {
      return
    }
    context.performBlockAndWait {
      self.firebase = FirebaseService.shareInstance.observeProfile(id: id) { data in
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
      if let theId = dictionary["id"] as? String {
        self.id = theId
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

      if let imageUrl = dictionary["imageUrl"] as? String {
        self.imageUrl = imageUrl
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
    if let imageUrl = imageUrl {
      data["imageUrl"] = imageUrl
    }
    return data
  }

  func updateFirebase(completion: ((error: NSError?) -> Void)? = nil) {
    guard let id = id else {
      return
    }
    var data = toDictionary()
    if let image = image where imageChanged {
      FirebaseService.shareInstance.uploadProfileImage(image, userId: id) { url, error in
        if let error = error {
          completion?(error: error)
        } else {
          if let url = url {
            data["imageUrl"] = url.absoluteString
          }
          self.imageChanged = false
          FirebaseService.shareInstance.updateProfile(id: id, data: data) { error, firebase in
            completion?(error: error)
          }
        }
      }
    } else {
      FirebaseService.shareInstance.updateProfile(id: id, data: data) { error, firebase in
        completion?(error: error)
      }
    }
  }
}
