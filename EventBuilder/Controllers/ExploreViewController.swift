//
//  ExploreViewController.swift
//  EventBuilder
//
//  Created by Buu Bui on 7/2/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ExploreViewController: UIViewController {

  @IBOutlet weak var mapView: MKMapView!

  let locationManager = CLLocationManager()

  var data =  [String: AnyObject]()
  var keys = [String]()
  var receiveKeys = [String]()


  class func instantiateStoryboard() -> ExploreViewController {
    return UIStoryboard.mainStoryBoard.instantiateViewControllerWithIdentifier("ExploreViewController") as! ExploreViewController
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupLocationManager()
    reload()
  }

  private func setupLocationManager() {
    locationManager.delegate = self
    if CLLocationManager.authorizationStatus() == .NotDetermined {
      locationManager.requestWhenInUseAuthorization()
    }
    locationManager.distanceFilter = Constant.locationDistanceFilter
  }

  func reload() {
    var receivedFirst = false
    FirebaseService.shareInstance.getAllEvents() { keys, receivedDict, receivedId in
      if !receivedFirst {
        self.keys = keys
        receivedFirst = true
      }
      self.data[receivedId] = receivedDict
      self.receiveKeys.append(receivedId)
      let annotation = EventAnnotation(event: receivedDict)
      self.mapView.addAnnotation(annotation)
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let event = sender as? [String: AnyObject], controller = segue.destinationViewController as? EventDetailsViewController where segue.identifier == "showEventDetails" {
      controller.event = event
    }
  }
}

extension ExploreViewController: MKMapViewDelegate {

  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    var annotationView: MKAnnotationView!
    if let dequeueAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("eventAnnotationView") {
      annotationView = dequeueAnnotationView
    } else {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "eventAnnotationView")
      annotationView.canShowCallout = true
    }
    annotationView.annotation = annotation
    annotationView.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
    return annotationView
  }

  func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    guard let annotation = view.annotation as? EventAnnotation else {
      return
    }
    performSegueWithIdentifier("showEventDetails", sender: annotation.event)
  }
}


extension ExploreViewController: CLLocationManagerDelegate {

  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
      manager.startUpdatingLocation()
    }
  }

  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let newLocation = locations.last!
    print("didUpdateToLocation", newLocation)
    mapView.region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
  }
}
