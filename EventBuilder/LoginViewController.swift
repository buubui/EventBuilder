//
//  LoginViewController.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/3/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import Material
import Firebase
import SwiftValidator
import FlatUIKit
import ChameleonFramework

class LoginViewController: UIViewController {
  @IBOutlet weak var emailTextField: BTextField!
  @IBOutlet weak var passwordTextField: BTextField!
  @IBOutlet weak var loginButton: RaisedButton!
  @IBOutlet weak var labelIcon: UILabel!
  @IBOutlet weak var iconBg: MaterialView!

  private let validator = Validator()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupValidator()
    iconBg.shape = .Circle
    iconBg.backgroundColor = UIColor.flatBlackColor()
    iconBg.depth = .Depth3
    labelIcon.font = UIFont.iconFontWithSize(80)
    labelIcon.textColor = UIColor.flatWhiteColorDark()
    labelIcon.text = NSString.iconStringForEnum(.FUICalendar)
    print(labelIcon.text)
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

  func loginWithPassword() {
    validateWithCompletion(textField: nil) {
      self.showLoadingActivity(text: "Logging in...")
      FirebaseService.shareInstance.signIn(email: self.emailTextField.text!, password: self.passwordTextField.text!) { [weak self] error in
        defer {
          self?.hideLoadingActivity(success: error == nil)
        }
        if let error = error {
          print(error)
        } else {
          print(FirebaseService.shareInstance.authData)
          self?.performSegueWithIdentifier("showMainView", sender: self)
        }
      }
    }
  }

  @IBAction func loginButtonDidTap(sender: RaisedButton) {
    loginWithPassword()
  }
}

extension LoginViewController: UITextFieldDelegate {

  func textFieldDidBeginEditing(textField: UITextField) {
    guard let bField = textField as? BTextField else {
      return
    }
    bField.validationError = nil
  }

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == passwordTextField {
      view.endEditing(true)
      loginWithPassword()
    } else {
      passwordTextField.becomeFirstResponder()
    }
    return true
  }

  func textFieldDidEndEditing(textField: UITextField) {
    guard let bField = textField as? BTextField else {
      return
    }
    validateWithCompletion(textField: bField, completion: nil)
  }
}

//extension LoginViewController: ValidationDelegate {
//  func validationSuccessful() {
//
//  }
//
//  func validationFailed(errors: [UITextField : ValidationError]) {
//    for (textField, error) in errors {
//      if let bField = textField as? BTextField {
//        bField.detailLabel?.text = error.errorMessage
//        bField.detailLabelHidden = false
//      }
//    }
//  }
//}