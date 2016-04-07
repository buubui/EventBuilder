//
//  UIViewController+Extension.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/5/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import EZLoadingActivity

extension UIViewController {

  func showLoadingActivity(text text:String) {
    EZLoadingActivity.show(text, disableUI: true)
  }

  func hideLoadingActivity(success success: Bool?, animated: Bool = true) {
    EZLoadingActivity.hide(success: success, animated: animated)
  }

}
