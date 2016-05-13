//
//  IconView.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/20/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit

@IBDesignable class IconView: UIView {

//  required init?(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//  }
//
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//  }

  override func drawRect(rect: CGRect) {
    StyleKit.drawCalendar(frame: bounds, calendarColor: tintColor, wandColor: tintColor)
  }
}
