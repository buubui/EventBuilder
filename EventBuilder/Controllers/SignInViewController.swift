//
//  SignInViewController.swift
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

class SignInViewController: SignInBaseViewController {

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    emailTextField.text = "buu@suremail.info"
    passwordTextField.text = "password"
  }

  func signInWithPassword() {
    validateWithCompletion(textField: nil) {
      self.showLoadingActivity(text: "Signing in...")
      FirebaseService.shareInstance.signIn(email: self.emailTextField.text!, password: self.passwordTextField.text!) { [weak self] error in
        defer {
          self?.hideLoadingActivity(success: error == nil)
        }
        if let error = error {
          print(error.localizedDescription)
          if error.domain == "FirebaseAuthentication" && (error.code == -8 || error.code == -6) {
            self?.showNotificationMessage("Invalid email or password", error: true)
          } else {
            self?.showNotificationMessage(error.localizedDescription, error: true)
          }
        } else {
          self?.performSegueWithIdentifier("showMainView", sender: self)
        }
      }
    }
  }

  @IBAction func signInButtonDidTap(sender: RaisedButton) {
    signInWithPassword()
  }

  override func extraButtonDidTap(sender: UIButton) {
    showSignUpScreen()
  }

  func showSignUpScreen() {
    let controller = SignUpViewController.instantiateStoryboard()
    navigationController?.pushViewController(controller, animated: true)
  }
}

extension SignInViewController {

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == passwordTextField {
      view.endEditing(true)
      signInWithPassword()
    } else {
      passwordTextField.becomeFirstResponder()
    }
    return true
  }
}
