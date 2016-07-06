//
//  ProfileViewController.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/11/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import Material
import Haneke

class ProfileViewController: UIViewController {

  var user: User? {
    willSet {
      if let user = user {
        user.stopObserveFirebaseChange()
      }
    }
    didSet {
      registerUserNotification()
    }
  }

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
  @IBOutlet weak var profilePictureContainerView: MaterialView!
  @IBOutlet weak var profilePictureView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!

  class func instantiateStoryboard() -> ProfileViewController {
    return UIStoryboard.mainStoryBoard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
    profilePictureContainerView.backgroundColor = UIColor.blueColor()
    profilePictureContainerView.depth = .Depth5
    if user == nil {
      let context = CoreDataStackManager.sharedInstance.mainQueueContext
      context.performBlock {
        self.user = User.findOrNewByUId(User.currentUId, context: context)
        self.reloadData()
      }
    }
  }

  func registerUserNotification() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: Constant.Notification.didChangeUserObject, object: nil)
    if let user = user {
      NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileViewController.didChangeUserObject(notification:)), name: Constant.Notification.didChangeUserObject, object: user)
      user.startObserveFirebaseChange()
    }
  }

  func didChangeUserObject(notification notification: NSNotification) {
    reloadData()
  }

  func reloadData() {
    if let image = user?.image {
      profilePictureView.image = image
    } else {
      profilePictureView.image = UIImage.defaultProfilePicture()
      guard let user = user, imageUrlString = user.imageUrl, imageUrl = NSURL(string: imageUrlString) else {
        return
      }
      profilePictureView.hnk_setImageFromURL(imageUrl)
    }
    nameLabel.text = user?.name
    tableView.reloadData()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let navController = segue.destinationViewController as? CustomNavigationController, controller = navController.topViewController as? EditProfileViewController where segue.identifier == "showEditProfile" {
      controller.user = user
    }
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
    guard let _ = user else {
      return 0
    }
    return 2
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell")!
    cell
    guard let item = ProfileCellItem(rawValue: indexPath.row), user = user else {
      return cell
    }
    cell.textLabel?.text = item.label
    cell.detailTextLabel?.text = indexPath.row == 0 ? user.email : user.phone
    return cell
  }
}