//
//  Event.swift
//  
//
//  Created by Buu Bui on 4/15/16.
//
//

import Foundation
import CoreData

enum EventTimeType: Int {
  case Current = 0
  case Upcomming
  case Past

  var title: String {
    switch self {
    case .Current: return "Current"
    case .Upcomming: return "Upcomming"
    case .Past: return "Past"
    }
  }
}

class Event: NSManagedObject {

  static let entityName = "Event"

  override var saveNotificationName: String {
    return "EventDidSave"
  }
  
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

    if let theDetails = dictionary["details"] as? String {
      details = theDetails
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

    if let creatorId = dictionary["creator"] as? String, context = managedObjectContext {
      if let user = User.findById(creatorId, context: context) {
        creator = user
      } else {
        User.getUser(userId: creatorId, context: context) { receivedUser in
          context.performBlockAndWait {
            self.creator = receivedUser
            self.save()

          }
        }
      }
    }
    NSNotificationCenter.defaultCenter().postNotificationName(Constant.Notification.didChangeEventCreator, object: self)
    save()
  }

  func createFirebaseEvent(completion: ((error: NSError?) -> Void)? = nil) {
    if let context = managedObjectContext where  creator == nil {
      creator = User.findOrNewById(User.currentUId, context: context)
      participants = NSSet(object: creator!)
    }
    let data = toDictionary()
    FirebaseService.shareInstance.createEvent(data) { error, firebase in
      if let error = error {
        completion?(error: error)
        return
      } else {
        self.managedObjectContext?.performBlock {
          self.id = firebase.key
          self.save()
          completion?(error: nil)
        }
      }
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
    dict["details"] = details
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

  func shortDateRangeString() -> String {
    guard let startDate = startDate, endDate = endDate else { return "" }
    var string = startDate.toString(format: "MMM d")
    let endString = endDate.toString(format: "MMM d")
    if string != endString {
      string += " - \(endString)"
    }

    return string
  }

  func fullDateRangeString() -> String {
    guard let startDate = startDate, endDate = endDate else { return "" }
    var string = startDate.toString(format: "MMM d 'at' h:mm a")
    let endDateString = endDate.toString(format: "MMM d")
    let endTimeString = endDate.toString(format: "h:mm a")
    if string.containsString(endDateString) {
      if !string.contains(endTimeString) {
        string += " to \(endTimeString)"
      }
    } else {
      string += " to \(endDateString) at \(endTimeString)"
    }

    return string
  }

  var timeType: EventTimeType? {
    if let startDate = startDate, endDate = endDate {
      let currentDate = NSDate()
      if startDate > currentDate {
        return .Upcomming
      } else if endDate > currentDate {
        return .Current
      } else {
        return .Past
      }
    }
    return nil
  }
}
