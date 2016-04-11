//
//  SignInBaseViewController.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/9/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import Material
import SwiftValidator

class SignInBaseViewController: UIViewController {
  @IBOutlet weak var emailTextField: BTextField!
  @IBOutlet weak var passwordTextField: BTextField!
  @IBOutlet weak var labelIcon: UILabel!
  @IBOutlet weak var iconBg: MaterialView!

  private let validator = Validator()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupIcon()
    setupValidator()
  }

  func setupIcon() {
    iconBg.shape = .Circle
    iconBg.backgroundColor = UIColor.flatBlackColor()
    iconBg.depth = .Depth3
    labelIcon.font = UIFont.iconFontWithSize(80)
    labelIcon.textColor = UIColor.flatWhiteColorDark()
    labelIcon.text = NSString.iconStringForEnum(.FUICalendar)
  }

  func setupValidator() {
    validator.registerField(emailTextField, errorLabel: emailTextField.detailLabel!, rules: [RequiredRule(), EmailRule()])
    validator.registerField(passwordTextField, errorLabel: passwordTextField.detailLabel!, rules: [RequiredRule()])
  }

  func validateWithCompletion(textField textField: BTextField?, completion: (() -> Void)?) {
    guard let textField = textField else {
      validator.validate { errors in
        if errors.isEmpty {
          completion?()
        } else {
          runInMainThread {
            for (textField, error) in errors {
              if let bField = textField as? BTextField {
                bField.validationError = error
              }
            }
          }
        }
      }
      return
    }
    validator.validateField(textField) { error in
      textField.validationError = error
    }

  }

  @IBAction func extraButtonDidTap(sender: UIButton) { }
}

extension SignInBaseViewController: UITextFieldDelegate {

  func textFieldDidBeginEditing(textField: UITextField) {
    guard let bField = textField as? BTextField else {
      return
    }
    bField.validationError = nil
  }

  func textFieldDidEndEditing(textField: UITextField) {
    guard let bField = textField as? BTextField else {
      return
    }
    validateWithCompletion(textField: bField, completion: nil)
  }
}
