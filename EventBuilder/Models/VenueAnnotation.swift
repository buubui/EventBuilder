//
//  VenueAnnotation.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/27/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import MapKit

class VenueAnnotation: NSObject, MKAnnotation {
  var venue: FQVenue
  init(venue aVenue: FQVenue) {
    venue = aVenue
  }
  
  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: venue.location.latitude, longitude: venue.location.longitude)
  }
  var title: String? {
    return venue.name
  }
  var subtitle: String? {
    return venue.location.address
  }
}
