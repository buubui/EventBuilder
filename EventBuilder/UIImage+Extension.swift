//
//  UIImage+Extension.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/14/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit

extension UIImage {
  var base64: String? {

    guard let data = UIImageJPEGRepresentation(self, 0.8) else {
      return nil
    }
    return data.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
  }

  class func fromBase64(base64: String) -> UIImage? {
    guard let data = NSData(base64EncodedString: base64, options: .IgnoreUnknownCharacters) else {
      return nil
    }
    return UIImage(data: data)
  }

  class func defaultProfilePicture() -> UIImage {
    return UIImage(named: Constant.defaultProfilePicture)!
  }
}
