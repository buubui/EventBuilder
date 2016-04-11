//
//  ProfileViewController.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/11/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

  class func instantiateStoryboard() -> ProfileViewController {
    return UIStoryboard.mainStoryBoard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
