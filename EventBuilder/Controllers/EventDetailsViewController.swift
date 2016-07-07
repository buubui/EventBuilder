//
//  EventDetailsViewController.swift
//  EventBuilder
//
//  Created by Buu Bui on 6/18/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import MapKit
import EZSwiftExtensions

class EventDetailsViewController: UIViewController {

  @IBOutlet weak var venueLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var detailDateLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var scrollView: UIScrollView!

  var event: Event!
  var attended: Bool = false {
    didSet {
      reloadRightBarButton()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    checkAttended()
    print(event)
    nameLabel.text = event.name
    descriptionLabel.text = "descriptionLabel"
    if let startDate = event.startDate, endDate = event.endDate {
      var titleDate = startDate.toString(format: "MMM d")
      let endTitleDate = endDate.toString(format: "MMM d")
      if endTitleDate != titleDate {
        titleDate += " -  \(endTitleDate)"
      }
      let detailDate = startDate.toString(format: "MMM d 'at' h:mm a") + " to " + endDate.toString(format: "MMM d 'at' h:mm a")
      dateLabel.text =  titleDate
      detailDateLabel.text = detailDate
    }
    if let place = event.place {

      let coordinate = CLLocationCoordinate2D(latitude: place.latitude!.doubleValue, longitude: place.longitude!.doubleValue)
      mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500)
      mapView.addAnnotation(EventAnnotation(event: event))
      venueLabel.text = place.name
    }
  }

  func checkAttended() {
    guard let eventId = event.id else {
      return
    }
    FirebaseService.shareInstance.isAttendEvent(eventId, userId: User.currentUId) { value in
      self.attended = value
    }
  }

  func reloadRightBarButton() {
    navigationItem.rightBarButtonItem?.title = attended ? "Participants" : "Attend"
  }

  @IBAction func rightBarButtonDidTap(sender: UIBarButtonItem) {
    if attended {
      performSegueWithIdentifier("showParticipants", sender: nil)
    } else if let eventId = event.id {
      FirebaseService.shareInstance.attendEvent(eventId, userId: User.currentUId) { error, firebase in
        if let error = error{
          self.showAlert(message: error.localizedDescription, completion: nil)
        } else {
          self.checkAttended()
        }
      }
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let navController = segue.destinationViewController as? UINavigationController, controller = navController.topViewController as? ParticipantsViewController where segue.identifier == "showParticipants" {
      controller.event = event
    }
  }
}
