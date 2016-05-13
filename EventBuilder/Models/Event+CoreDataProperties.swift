//
//  Event+CoreDataProperties.swift
//  
//
//  Created by Buu Bui on 5/4/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Event {

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var status: String?
    @NSManaged var startDate: NSDate?
    @NSManaged var endDate: NSDate?
    @NSManaged var participants: NSSet?
    @NSManaged var place: Place?

}
