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

  func createFirebaseEvent(completion: ((error: NSError?) -> Void)? = nil) {
    let data = toDictionary()
    FirebaseService.shareInstance.createEvent(data, completion: completion)
  }

  func toDictionary() -> [String: AnyObject] {
    var dict = [String: AnyObject]()
    dict["name"] = name
    dict["status"] = status
    dict["startDate"] = startDate?.timeIntervalSince1970
    if let endDate = endDate {
      dict["endDate"] = endDate.timeIntervalSince1970
    }
    if let place = place {
      dict["place"] = place.toDictionary()
    }

    return dict
  }
}
