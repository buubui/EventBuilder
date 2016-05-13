//
//  BTextView.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/29/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import Material

class BTextView: TextView {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupUI()
  }

  func setupUI() {
    placeholderLabel = UILabel()
    placeholderLabel!.textColor = MaterialColor.grey.base
    titleLabel = UILabel()
    titleLabel!.font = RobotoFont.mediumWithSize(12)
    titleLabelColor = MaterialColor.grey.base
    titleLabelActiveColor = MaterialColor.blue.accent3
  }

}
