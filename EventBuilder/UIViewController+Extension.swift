//
//  UIViewController+Extension.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/5/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import EZLoadingActivity
import StatusBarNotificationCenter
import FlatUIKit

extension UIViewController {

  func showLoadingActivity(text text:String) {
    EZLoadingActivity.show(text, disableUI: true)
  }

  func hideLoadingActivity(success success: Bool?, animated: Bool = true) {
    EZLoadingActivity.hide(success: success, animated: animated)
  }

  func showNotificationMessage(message: String, error: Bool) {
    var notificationCenterConfiguration = NotificationCenterConfiguration(baseWindow: UIApplication.sharedApplication().delegate!.window!!)
    notificationCenterConfiguration.style = .NavigationBar
    var notificationLabelConfiguration = NotificationLabelConfiguration()
    notificationLabelConfiguration.backgroundColor = error ? UIColor.flatRedColor() : UIColor.flatGreenColor()
    notificationLabelConfiguration.textColor = UIColor.flatWhiteColor()
    StatusBarNotificationCenter.showStatusBarNotificationWithMessage(message, forDuration: 2, withNotificationCenterConfiguration: notificationCenterConfiguration, andNotificationLabelConfiguration: notificationLabelConfiguration)
  }

  func setupRootViewController() {
    let button = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: #selector(UIViewController.presentLeftMenuViewController))
    button.accessibilityLabel = "LeftMenuBarButton"
    navigationItem.leftBarButtonItem = button
  }
}
