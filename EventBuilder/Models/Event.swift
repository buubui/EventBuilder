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
}
