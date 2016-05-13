//
//  Place.swift
//  
//
//  Created by Buu Bui on 4/15/16.
//
//

import Foundation
import CoreData

class Place: NSManagedObject {

  static let entityName = "Place"

  override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    super.init(entity: entity, insertIntoManagedObjectContext: context)
  }

  convenience init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {

    let entity =  NSEntityDescription.entityForName(Place.entityName, inManagedObjectContext: context)!
    self.init(entity: entity, insertIntoManagedObjectContext: context)

    if let theId = dictionary["Id"] as? String {
      id = theId
    }

    if let theName = dictionary["name"] as? String {
      name = theName
    }

    if let theAdress = dictionary["address"] as? String {
      address = theAdress
    }

    if let theCity = dictionary["city"] as? String {
      city = theCity
    }

    if let lat = dictionary["latitude"] as? Double {
      latitude = NSNumber(double: lat)
    }

    if let long = dictionary["longitude"] as? Double {
      longitude = NSNumber(double: long)
    }
  }

  convenience init(venue: FQVenue, context: NSManagedObjectContext) {
    let entity =  NSEntityDescription.entityForName(Place.entityName, inManagedObjectContext: context)!
    self.init(entity: entity, insertIntoManagedObjectContext: context)
    id = venue.id
    name = venue.name
    latitude = venue.location.latitude
    longitude = venue.location.longitude
    address = venue.location.address
    city = venue.location.city
  }

  func toDictionary() -> [String: AnyObject] {
    var dict = [String: AnyObject]()
    dict["id"] = id
    dict["name"] = name
    dict["latitude"] = latitude
    dict["longitude"] = longitude
    dict["address"] = address
    dict["city"] = city

    return dict
  }
}
