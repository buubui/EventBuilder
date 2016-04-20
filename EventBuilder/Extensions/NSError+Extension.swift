//
//  NSError+Extension.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/18/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit

extension NSError {

  convenience init(message: String) {
    self.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
  }

  class func invalidDataError() -> NSError {
    return NSError(message: "Invalid Data")
  }

}
