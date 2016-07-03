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
  let event: [String: AnyObject]
  init(event: [String: AnyObject]) {
    self.event = event
    super.init()
    title = event["name"] as? String
    let place = event["place"] as! [String: AnyObject]
    coordinate = CLLocationCoordinate2D(latitude: place["latitude"] as! Double, longitude: place["longitude"] as! Double)
  }
}
