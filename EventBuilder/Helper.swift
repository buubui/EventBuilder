//
//  Helper.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/5/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit

class Helper {
  class func isTestMode() -> Bool {
    #if DEBUG
      if env("TESTING") == "1" {
        return true
      }
    #endif
    return false
  }

  class func env(key: String) -> String? {
    let dict = NSProcessInfo.processInfo().environment
    if dict[key] == nil {
      print("CAN NOT LOAD ENV VAR: \(key)")
    }
    return dict[key]
  }

  class func waitForTimeInterval(interval: NSTimeInterval) {
    NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: interval))
  }
}

func runInMainThread(completion: (() -> Void)) {
  dispatch_async(dispatch_get_main_queue()) {
    completion()
  }
}

