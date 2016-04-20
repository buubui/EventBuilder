//
//  Event+CoreDataProperties.swift
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

extension Event {

    @NSManaged var name: String?
    @NSManaged var timeInterval: NSNumber?
    @NSManaged var status: String?
    @NSManaged var id: String?
    @NSManaged var place: NSManagedObject?
    @NSManaged var participants: NSSet?

}
