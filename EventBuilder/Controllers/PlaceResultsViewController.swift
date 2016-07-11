//
//  PlaceResultsViewController.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/15/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class PlaceResultsViewController: UIViewController {

  @IBOutlet weak var mapView: MKMapView!

  var query: String = ""

  let locationManager = CLLocationManager()

  var data = [FQVenue]() {
    didSet {
      reloadData()
    }
  }

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
    locationManager.startUpdatingLocation()
  }

  func reloadData() {
    runInMainThread {
      self.mapView.removeAnnotations(self.mapView.annotations)
      for venue in self.data {
        self.mapView.addAnnotation(VenueAnnotation(venue: venue))
      }
    }
  }

  func startSearch(latitude latitude: Double, longitude: Double) {
    HttpClient.sharedInstance.cancelAll()
    FoursquareService.shareInstance.search(query: query, latitude: latitude, longitude: longitude) { [weak self] error, data in
      if let data = data {
        self?.data = data
      }
    }
  }

  func selectVenueAnnotation(annotation: VenueAnnotation) {
    performActionIfOnline {
      self.performSegueWithIdentifier("showNewEvent", sender: annotation)
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let controller = segue.destinationViewController as? NewEventViewController, annotation = sender as? VenueAnnotation where segue.identifier == "showNewEvent" {
      controller.venue = annotation.venue
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
    mapView.setRegion(MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500), animated: true)
  }
}

extension PlaceResultsViewController: MKMapViewDelegate {

  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "VenueAnnotation")
    annotationView.canShowCallout = true
    annotationView.accessibilityLabel = annotation.title!
    annotationView.rightCalloutAccessoryView = UIButton(type: .ContactAdd)
    annotationView.rightCalloutAccessoryView?.accessibilityLabel = "calloutAccessoryButton"
    return annotationView
  }

  func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    guard let annotation = view.annotation as? VenueAnnotation else {
      return
    }
    selectVenueAnnotation(annotation)
  }

  func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    startSearch(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
  }
}
