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
import DOAlertController

extension UIViewController {

  func showLoadingActivity(text text:String) {
    EZLoadingActivity.show(text, disableUI: true)
  }

  func hideLoadingActivity(success success: Bool? = nil, animated: Bool = true) {
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

  func showAlert(message message: String, completion: (() -> Void)?) {
    let alertController = DOAlertController(title: nil, message: message, preferredStyle: .Alert)
    alertController.alertViewBgColor = UIColor.flatWhiteColor()
    alertController.buttonBgColor[.Default] = UIColor.flatSkyBlueColorDark()
    alertController.buttonBgColor[.Cancel] = UIColor.flatGrayColor()
    alertController.buttonHeight = 30
    alertController.buttonMargin = 15
    alertController.buttonCornerRadius = 2
    var cancelTitle = "OK"
    if let completion = completion{
      cancelTitle = "Cancel"
      let okAction = DOAlertAction(title: "OK", style: .Default) { action in
        alertController.dismissViewControllerAnimated(true) {
          Helper.waitForTimeInterval(0.2)
          completion()
        }
      }
      alertController.addAction(okAction)
    }
    let cancelAction = DOAlertAction(title: cancelTitle, style: .Cancel, handler: nil)
    alertController.addAction(cancelAction)
    presentViewController(alertController, animated: true, completion: nil)
  }

  func showActionSheet(message message: String, actions: [(title: String, action: (() -> ()))]) {
    let alertController = DOAlertController(title: nil, message: message, preferredStyle: .ActionSheet)
    alertController.alertViewBgColor = UIColor.flatWhiteColor()
    alertController.buttonBgColor[.Default] = UIColor.flatSkyBlueColorDark()
    alertController.buttonBgColor[.Cancel] = UIColor.flatGrayColor()
    for actionInfo in actions {
      let action = DOAlertAction(title: actionInfo.title, style: .Default) { action in
        actionInfo.action()
      }
      alertController.addAction(action)
    }
    alertController.addAction(DOAlertAction(title: "Cancel", style: .Cancel, handler: nil))
    presentViewController(alertController, animated: true, completion: nil)
  }
}
