//
//  PlaceResultsViewController.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/15/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import CoreLocation

class PlaceResultsViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!

  var query: String = ""

  let locationManager = CLLocationManager()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupLocationManager()
  }

  private func setupLocationManager() {
    locationManager.delegate = self
    if CLLocationManager.authorizationStatus() == .NotDetermined {
      locationManager.requestWhenInUseAuthorization()
    }
    locationManager.distanceFilter = Constant.locationDistanceFilter
  }

  func startSearch(location location: CLLocation) {
    let coordinate = location.coordinate
    FoursquareService.shareInstance.explore(query: query, latitude: coordinate.latitude, longitude: coordinate.longitude) { error, data in
      print(data)
    }
  }
}

extension PlaceResultsViewController: CLLocationManagerDelegate {

  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
      manager.startUpdatingLocation()
    }
  }

  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let newLocation = locations.last!
    print("didUpdateToLocation", newLocation)
    startSearch(location: newLocation)
  }
}
