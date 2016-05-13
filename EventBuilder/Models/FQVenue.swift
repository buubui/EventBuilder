//
//  FQVenue.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/27/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

struct FQVenue {
  var id: String
  var name: String
  var location: FQLocation
  init?(dictionary: [String: AnyObject]) {
    guard let theId = dictionary["id"] as? String, theName = dictionary["name"] as? String, locationDict = dictionary["location"] as? [String: AnyObject], theLocation = FQLocation(dictionary: locationDict) else {
      return nil
    }
    id = theId
    name = theName
    location = theLocation
  }
}
