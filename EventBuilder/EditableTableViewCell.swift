//
//  EditableTableViewCell.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/12/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import Material

class EditableTableViewCell: MaterialTableViewCell {

  @IBOutlet weak var headingLabel: UILabel!
  @IBOutlet weak var inputTextField: UITextField!

  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
