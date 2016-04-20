//
//  PlaceSearchViewController.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/18/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit

class PlaceSearchViewController: UIViewController {

  @IBOutlet weak var searchField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    guard let controller = segue.destinationViewController as? PlaceResultsViewController where segue.identifier == "showSearchResults" else {
      return
    }
    controller.query = searchField.text!
  }
}

extension PlaceSearchViewController: UITextFieldDelegate {

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    performSegueWithIdentifier("showSearchResults", sender: self)
    return true
  }
}