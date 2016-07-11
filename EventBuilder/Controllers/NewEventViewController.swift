//
//  NewEventViewController.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/27/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import ForecastView
import Material
import EZSwiftExtensions

class NewEventViewController: UIViewController {

  @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var forecastView: ForecastView!
  @IBOutlet weak var venueLabel: UILabel!
  @IBOutlet weak var nameTextField: BTextField!
  @IBOutlet weak var startDateButton: FlatButton!
  @IBOutlet weak var endDateButton: FlatButton!
  @IBOutlet weak var descriptionTextView: BTextView!
  @IBOutlet weak var startDatePicker: UIDatePicker!
  @IBOutlet weak var endDatePicker: UIDatePicker!

  var venue: FQVenue!

  override func viewDidLoad() {
    super.viewDidLoad()
    forecastView.dataSource = WundergroundDataSource(apiKey: Constant.Wunderground.apiKey)
    forecastView.coordinates = venue.location.coordinate
    setupUI()
  }

  func setupUI() {
    venueLabel.text = venue.name
    descriptionTextView.placeholderLabel?.text = "Description"
    startDatePicker.minimumDate = NSDate()
    endDatePicker.minimumDate = NSDate()
  }

  func eventInfo() -> [String: AnyObject] {
    return [
      "name" : nameTextField.text!,
      "details": descriptionTextView.text,
      "startDate": startDatePicker.date.timeIntervalSince1970,
      "endDate": endDatePicker.date.timeIntervalSince1970,
      "description": descriptionTextView.text]
  }

  func createEvent() {
    showLoadingActivity(text: "Updating...")
    let context = CoreDataStackManager.sharedInstance.mainQueueContext
    let event = Event(dictionary: eventInfo(), context: context)
    let place = Place(venue: venue, context: context)
    event.place = place
    if let creator = User.currentUser(context: context) {
      event.creator = creator
      event.participants = NSSet(object: creator)
    }
    event.createFirebaseEvent { [weak self] error in
      print(error)
      defer {
        self?.hideLoadingActivity()
      }
      if let error = error {
        self?.showNotificationMessage(error.localizedDescription, error: true)
        return
      }
      NSNotificationCenter.defaultCenter().postNotificationName(Constant.Notification.didCreateEvent, object: event)
      self?.dismissViewControllerAnimated(true, completion: nil)
    }
  }

  @IBAction func startDateButtonDidTap(sender: FlatButton) {
    view.endEditing(true)
    startDatePicker.minimumDate = NSDate()
    startDatePicker.hidden = !startDatePicker.hidden
    endDatePicker.hidden = true
    startDatePickerDidChangeValue(startDatePicker)
  }

  @IBAction func endDateButtonDidTap(sender: FlatButton) {
    view.endEditing(true)
    endDatePicker.minimumDate = startDatePicker.date
    endDatePicker.hidden = !endDatePicker.hidden
    startDatePicker.hidden = true
    endDatePickerDidChangeValue(endDatePicker)
  }

  @IBAction func startDatePickerDidChangeValue(sender: UIDatePicker) {
    let timeString = sender.date.toString(format: "MMM d, yyyy 'at' h:mm a")
    startDateButton.setTitle("From \(timeString)", forState: .Normal)
    if endDatePicker.date < startDatePicker.date {
      endDatePicker.date = startDatePicker.date
      endDatePickerDidChangeValue(endDatePicker)
    }
  }

  @IBAction func endDatePickerDidChangeValue(sender: UIDatePicker) {
    let timeString = sender.date.toString(format: "MMM d, yyyy 'at' h:mm a")
    endDateButton.setTitle("To \(timeString)", forState: .Normal)
  }

  @IBAction func createButtonDidTap(sender: UIBarButtonItem) {
    view.endEditing(true)
    performActionIfOnline {
      self.createEvent()
    }
  }
}
