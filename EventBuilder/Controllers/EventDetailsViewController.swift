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
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var detailDateLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var creatorLabel: UILabel!

  var event: Event!
  var attended: Bool = false {
    didSet {
      reloadRightBarButton()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    checkAttended()
    reload()

    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EventDetailsViewController.eventDidSave), name: event.saveNotificationName, object: event)
  }

  func eventDidSave() {
    print("Event Saved!")
  }

  func reload() {
    nameLabel.text = event.name
    descriptionLabel.text = event.details
    dateLabel.text =  event.shortDateRangeString()
    detailDateLabel.text = event.fullDateRangeString()
    if let creator = event.creator {
      creatorLabel.text = creator.name
    } else {
      creatorLabel.text = ""
    }
    if let place = event.place {
      let coordinate = CLLocationCoordinate2D(latitude: place.latitude!.doubleValue, longitude: place.longitude!.doubleValue)
      mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500)
      mapView.addAnnotation(EventAnnotation(event: event))
      venueLabel.text = place.name
      addressLabel.text = place.address
    }
  }

  func checkAttended() {
    guard let eventId = event.id where isOnline() else {
      return
    }
    FirebaseService.shareInstance.isAttendEvent(eventId, userId: User.currentUId) { value in
      self.attended = value
    }
  }

  func reloadRightBarButton() {
    navigationItem.rightBarButtonItem?.title = attended ? "Participants" : "Join"
  }

  @IBAction func rightBarButtonDidTap(sender: UIBarButtonItem) {
    if attended {
      performSegueWithIdentifier("showParticipants", sender: nil)
    } else if let eventId = event.id {
      FirebaseService.shareInstance.attendEvent(eventId, userId: User.currentUId) { error, firebase in
        if let error = error{
          self.showAlert(message: error.localizedDescription, completion: nil)
        } else {
          NSNotificationCenter.defaultCenter().postNotificationName(Constant.Notification.didAttendEvent, object: self)
          self.showNotificationMessage("Join this event successfully", error: false)
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
