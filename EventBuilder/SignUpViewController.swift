//
//  SignUpViewController.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/9/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit

class SignUpViewController: SignInBaseViewController {

  class func instantiateStoryboard() -> SignUpViewController {
    return UIStoryboard.mainStoryBoard.instantiateViewControllerWithIdentifier("SignUpViewController") as! SignUpViewController
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func signUp() {
    let email = emailTextField.text!
    let password = passwordTextField.text!
    validateWithCompletion(textField: nil) {
      self.showLoadingActivity(text: "Signing up...")
      FirebaseService.shareInstance.signUp(email: email, password: password) { [weak self] error in
        guard let unwrappedSelf = self else {
          return
        }
        defer {
          unwrappedSelf.hideLoadingActivity(success: error == nil)
        }
        if let error = error {
          print(error.domain)
          print(error.code)
          print(error.localizedDescription)
          if error.domain == "FirebaseAuthentication" && (error.code == -8 || error.code == -9) {
            unwrappedSelf.showNotificationMessage("This email address is already in use", error: true)
          } else {
            unwrappedSelf.showNotificationMessage(error.localizedDescription, error: true)
          }
        } else {
          unwrappedSelf.showSignInScreen {
            unwrappedSelf.showNotificationMessage("Sign up successfully, please sign in", error: false)
          }
        }
      }
    }
  }

  @IBAction func signupButtonDidTap(sender: UIButton) {
    signUp()
  }

  func showSignInScreen(completion: (() -> Void)? = nil) {
    navigationController?.popToRootViewControllerAnimated(true)
    completion?()
  }

  override func extraButtonDidTap(sender: UIButton) {
    showSignInScreen()
  }
}

extension SignUpViewController {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == passwordTextField {
      view.endEditing(true)
      signUp()
    } else {
      passwordTextField.becomeFirstResponder()
    }
    return true
  }
}


