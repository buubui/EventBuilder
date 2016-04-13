//
//  ProfileViewController.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/11/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import Material

class ProfileViewController: UIViewController {

  enum ProfileCellItem: Int {
    case Email, Phone

    var label: String {
      switch self {
      case .Email: return "Email"
      case .Phone: return "Phone"
      }
    }
  }

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var profilePictureView: MaterialView!

  let user = (email: "user@abc.com", phone: "+84 983 123 123")

  class func instantiateStoryboard() -> ProfileViewController {
    return UIStoryboard.mainStoryBoard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
    profilePictureView.depth = .Depth3
  }


  @IBAction func editButtonDidTap(sender: UIButton) {
    showEditProfileScreen()
  }

  func showEditProfileScreen() {
    performSegueWithIdentifier("showEditProfile", sender: self)
  }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell")!
    cell
    guard let item = ProfileCellItem(rawValue: indexPath.row) else {
      return cell
    }
    cell.textLabel?.text = item.label
    cell.detailTextLabel?.text = indexPath.row == 0 ? user.email : user.phone
    return cell
  }
}