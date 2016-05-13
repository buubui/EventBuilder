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
  }

  func eventInfo() -> [String: AnyObject] {
    return [
      "name" : nameTextField.text!,
      "startDate": startDatePicker.date,
      "endDate": endDatePicker.date,
      "description": descriptionTextView.text]
  }

  func createEvent() {
    showLoadingActivity(text: "Updating...")
    let context = CoreDataStackManager.sharedInstance.mainQueueContext
    let event = Event(dictionary: eventInfo(), context: context)
    let place = Place(venue: venue, context: context)
    event.place = place
    event.createFirebaseEvent { [weak self] error in
      defer {
        self?.hideLoadingActivity()
      }
      if let error = error {
        self?.showNotificationMessage(error.localizedDescription, error: true)
        return
      }
      self?.dismissViewControllerAnimated(true, completion: nil)
    }
  }

  @IBAction func startDateButtonDidTap(sender: FlatButton) {
    view.endEditing(true)
    startDatePicker.hidden = !startDatePicker.hidden
    endDatePicker.hidden = true
  }

  @IBAction func endDateButtonDidTap(sender: FlatButton) {
    view.endEditing(true)
    endDatePicker.hidden = !endDatePicker.hidden
    startDatePicker.hidden = true
  }

  @IBAction func startDatePickerDidChangeValue(sender: UIDatePicker) {
    startDateButton.setTitle("\(sender.date)", forState: .Normal)
  }

  @IBAction func endDatePickerDidChangeValue(sender: UIDatePicker) {
    endDateButton.setTitle("\(sender.date)", forState: .Normal)
  }

  @IBAction func createButtonDidTap(sender: UIBarButtonItem) {
    createEvent()
  }


}

