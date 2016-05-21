//
//  BTextField.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/5/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import Material
import SwiftValidator

class BTextField: TextField {

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupUI()
  }
  

  var validationError: ValidationError? {
    didSet {
      guard let validationError = validationError else {
        detailLabel?.text = ""
        detailLabelHidden = true
        return
      }
      detailLabel?.text = validationError.errorMessage
      detailLabelHidden = false
    }
  }

  private func setupUI() {
    borderStyle = .None
    bottomBorderColor = UIColor.flatGrayColor()
    placeholderTextColor = UIColor.flatGrayColor()
    titleLabel = UILabel()
    titleLabel!.font = RobotoFont.mediumWithSize(12)
    titleLabelColor = UIColor.flatGrayColor()
    titleLabelActiveColor = UIColor.flatSkyBlueColor()
    detailLabel = UILabel()
    detailLabel!.font = RobotoFont.mediumWithSize(12)
    detailLabelActiveColor = UIColor.pomegranateColor()
    detailLabelAutoHideEnabled = false
    detailLabelAnimationDistance = 2
    titleLabelAnimationDistance = 0
  }
}
