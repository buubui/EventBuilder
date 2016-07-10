//
//  Event+CoreDataProperties.swift
//  
//
//  Created by Buu Bui on 5/13/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Event {

    @NSManaged var endDate: NSDate?
    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var details: String?
    @NSManaged var startDate: NSDate?
    @NSManaged var status: String?
    @NSManaged var participants: NSSet?
    @NSManaged var place: Place?
    @NSManaged var creator: User?

}
