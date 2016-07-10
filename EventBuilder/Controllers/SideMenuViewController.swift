//
//  SideMenuViewController.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/10/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import ChameleonFramework
import SSASideMenu

class SideMenuViewController: UIViewController {

  enum MenuItem: Int {
    case MyEvent
    case Explore
    case Profile
    case SignOut

    var title: String {
      switch self {
      case .MyEvent: return "My Events"
      case .Explore: return "Explore"
      case .Profile: return "Profile"
      case .SignOut: return "Sign out"
      }
    }

    var icon: String {
      switch self {
      case .MyEvent: return "calendar"
      case .Explore: return "explore"
      case .Profile: return "profile"
      case .SignOut: return "sign_out"
      }
    }

    var controller: UIViewController? {
      switch self {
      case .MyEvent: return MyEventViewController.instantiateStoryboard()
      case .Explore:
        if isOnline() {
          return ExploreViewController.instantiateStoryboard()
        } else {
          return nil
        }
      case .Profile: return ProfileViewController.instantiateStoryboard()
      case .SignOut: return nil
      }
    }
  }

  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    view.backgroundColor = UIColor(gradientStyle: .Radial, withFrame: view.bounds, andColors: [UIColor.flatBlackColor(), UIColor.flatGrayColorDark()])
  }
}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 60
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell")!
    guard let item = MenuItem(rawValue: indexPath.row) else {
      return cell
    }
    cell.textLabel?.text = item.title
    cell.imageView?.image = UIImage(named: item.icon)
    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    guard let item = MenuItem(rawValue: indexPath.row) else {
      return
    }

    Helper.waitForTimeInterval(1)

    guard let sideMenuViewController = sideMenuViewController else {
      return
    }

    defer {
      sideMenuViewController.hideMenuViewController()
    }

    guard let controller = item.controller else {
      switch item {
      case .SignOut:
        showAlert(message: "Do you really want to sign out?") {
          FirebaseService.shareInstance.signOut()
        }

      default:
        if !isOnline() {
          showNotificationMessage("Cannot use this feature in offline mode, please check the internet connection.", error: true)
        }
      }
      return
    }

    let navController = sideMenuViewController.contentViewController as! UINavigationController
    navController.viewControllers = [controller]
    controller.setupRootViewController()
  }
}
