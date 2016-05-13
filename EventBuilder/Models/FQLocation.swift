//
//  FQLocation.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/27/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//
import CoreLocation

struct FQLocation {
  var distance: Double
  var address: String
  var city: String
  var latitude: Double
  var longitude: Double

  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }

  init?(dictionary: [String: AnyObject]) {
    guard let theDistance = dictionary["distance"] as? Double,
    theAddress = dictionary["address"] as? String, theCity = dictionary["city"] as? String, lat = dictionary["lat"] as? Double, long = dictionary["lng"] as? Double else {
      return nil
    }
    distance = theDistance
    address = theAddress
    city = theCity
    latitude = lat
    longitude = long
  }
}
