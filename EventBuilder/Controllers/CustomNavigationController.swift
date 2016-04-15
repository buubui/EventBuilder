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
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
}
