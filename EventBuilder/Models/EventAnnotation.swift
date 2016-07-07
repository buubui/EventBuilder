//
//  EventAnnotation.swift
//  EventBuilder
//
//  Created by Buu Bui on 7/2/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import MapKit

class EventAnnotation: MKPointAnnotation {
  let event: Event
  init(event: Event) {
    self.event = event
    super.init()
    title = event.name
    let place = event.place!
    coordinate = CLLocationCoordinate2D(latitude: place.latitude!.doubleValue, longitude: place.longitude!.doubleValue)
  }
}
