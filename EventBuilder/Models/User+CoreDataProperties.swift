//
//  User+CoreDataProperties.swift
//  
//
//  Created by Buu Bui on 7/10/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var email: String?
    @NSManaged var id: String?
    @NSManaged var imageUrl: String?
    @NSManaged var name: String?
    @NSManaged var phone: String?
    @NSManaged var events: NSSet?

}
