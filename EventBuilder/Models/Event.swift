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

    update(dictionary)
  }

  class func updateOrCreateByDictionary(dictionary: [String: AnyObject], context: NSManagedObjectContext) -> Event? {
    guard let anId = dictionary["id"] as? String else {
      return nil
    }
    let request = NSFetchRequest(entityName: Event.entityName)
    request.predicate = NSPredicate(format: "id = %@", anId)
    do {
      let result = try context.executeFetchRequest(request) as! [Event]
      if let event = result.first {
        event.update(dictionary)
        return event
      }
    } catch {
      print(error)
    }
    return Event(dictionary: dictionary, context: context)
  }

  func update(dictionary: [String: AnyObject]) {
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

    if let placeDict = dictionary["place"] as? [String: AnyObject], context = managedObjectContext {
      if let place = Place.updateOrCreateByDictionary(placeDict, context: context) {
        self.place = place
      }
    }

    save()
  }

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
      let context = CoreDataStackManager.sharedInstance.newPrivateQueueContext()
      context.performBlockAndWait {
        guard let user = User.updateOrCreateByDictionary(receivedDict, context: context) else {
          return
        }
        completion?(keys: keys, receivedUser: user)
      }
    }
  }

  class func getAllEvents(context: NSManagedObjectContext, completion:((keys:[String], receivedEvent: Event) -> Void)?) {
    FirebaseService.shareInstance.getAllEvents { keys, receivedDict, receivedId in
      context.performBlockAndWait {
        guard let event = Event.updateOrCreateByDictionary(receivedDict, context: context) else {
          return
        }
        completion?(keys: keys, receivedEvent: event)
      }
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
