//
//  Event.swift
//  
//
//  Created by Buu Bui on 4/15/16.
//
//

import Foundation
import CoreData


class Event: NSManagedObject {

  static let entityName = "Event"
  
  override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    super.init(entity: entity, insertIntoManagedObjectContext: context)
  }

  convenience init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {

    let entity =  NSEntityDescription.entityForName(Event.entityName, inManagedObjectContext: context)!
    self.init(entity: entity, insertIntoManagedObjectContext: context)

    if let theId = dictionary["id"] as? String {
      id = theId
    }
    if let theName = dictionary["name"] as? String {
      name = theName
    }

    if let theStatus = dictionary["status"] as? String {
      status = theStatus
    }

    if let timeInterval = dictionary["startDate"] as? NSTimeInterval {
      startDate = NSDate(timeIntervalSince1970: timeInterval)
    }

    if let timeInterval = dictionary["endDate"] as? NSTimeInterval {
      endDate = NSDate(timeIntervalSince1970: timeInterval)
    }
  }

//  class func updateOrCreateByDictionary(dictionary: [String: AnyObject], context: NSManagedObjectContext) -> Event? {
//    guard let anId = dictionary["id"] as? String else {
//      return nil
//    }
//    let request = NSFetchRequest(entityName: User.entityName)
//    request.predicate = NSPredicate(format: "id = %@", anId)
//    do {
//      let result = try context.executeFetchRequest(request) as! [User]
//      if let user = result.first {
//        user.update(dictionary)
//        return user
//      }
//    } catch {
//      print(error)
//    }
//    return User(dictionary: dictionary, context: context)
//  }

  func createFirebaseEvent(completion: ((error: NSError?) -> Void)? = nil) {
    if let context = managedObjectContext where  creator == nil {
      creator = User.findOrNewByUId(User.currentUId, context: context)
      participants = NSSet(object: creator!)
    }
    let data = toDictionary()
    FirebaseService.shareInstance.createEvent(data) { error, firebase in
      completion?(error: error)
    }
  }

  func getParticipants(completion:((keys:[String], receivedUser: User) -> Void)?) {
    guard let id = id else {
      return
    }
    FirebaseService.shareInstance.getParticipantsOfEventId(id) { keys, receivedDict, receivedUid in
      guard let user = User.updateOrCreateByDictionary(receivedDict, context: CoreDataStackManager.sharedInstance.newPrivateQueueContext()) else {
        return
      }
      completion?(keys: keys, receivedUser: user)
    }
  }

  func toDictionary() -> [String: AnyObject] {
    var dict = [String: AnyObject]()
    dict["name"] = name
    dict["status"] = status
    if let creator = creator {
      dict["creator"] = creator.id
    }
    if let startDate = startDate {
      dict["startDate"] = startDate.timeIntervalSince1970
    }
    if let endDate = endDate {
      dict["endDate"] = endDate.timeIntervalSince1970
    }
    if let place = place {
      dict["place"] = place.toDictionary()
    }
    if let participants = participants {
      var participantsDict = [String: Bool]()
      participants.forEach { p in
        participantsDict[p.id!!] = true
      }
      dict["participants"] = participantsDict
    }

    return dict
  }
}
