//
//  Place+CoreDataProperties.swift
//
//
//  Created by Buu Bui on 4/15/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Place {

  @NSManaged var id: String?
  @NSManaged var name: String?
  @NSManaged var address: String?
  @NSManaged var latitude: NSNumber?
  @NSManaged var longitude: NSNumber?
  @NSManaged var events: NSSet?

}
