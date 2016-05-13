//
//  CustomNavigationController.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/11/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBar.configureFlatNavigationBarWithColor(UIColor.pomegranateColor())
    navigationBar.tintColor = UIColor.flatWhiteColor()
    navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.flatWhiteColor()]
    navigationBar.translucent = false
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
}
