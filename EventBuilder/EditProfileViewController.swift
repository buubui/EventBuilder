//
//  EditProfileViewController.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/12/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import Material

class EditProfileViewController: UIViewController {

  enum EditProfileRow: Int {
    case Name
//    case Password
    case Phone
    case Address

  }

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var profilePictureView: MaterialView!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
  }

  @IBAction func cancelButtonDidTap(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }


  @IBAction func saveButtonDidTap(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("EditableProfileCell") as! EditableTableViewCell
    cell
    guard let row = EditProfileRow(rawValue: indexPath.row) else {
      return cell
    }

    switch row {
    case .Address:
      cell.headingLabel.text = "Address"
      cell.inputTextField.text = "100 Cong Hoa"
    case .Name:
      cell.headingLabel.text = "Name"
      cell.inputTextField.text = "First Last"
    case .Phone:
      cell.headingLabel.text = "Phone"
      cell.inputTextField.text = "098 765 4321"
    }
    return cell
  }
}
