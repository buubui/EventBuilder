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
import ChameleonFramework
import CoreData

class SignInViewController: SignInBaseViewController {

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    restoreSession()
  }

  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    hideLoadingActivity()
  }

  func signInWithPassword() {
    view.endEditing(true)
    validateWithCompletion(textField: nil) {
      self.showLoadingActivity(text: "Signing in...")
      FirebaseService.shareInstance.signIn(email: self.emailTextField.text!, password: self.passwordTextField.text!) { [weak self] error in
        defer {
          self?.hideLoadingActivity(success: error == nil)
        }
        if let error = error {
          if error.domain == "FirebaseAuthentication" && (error.code == -8 || error.code == -6) {
            self?.showNotificationMessage("Invalid email or password", error: true)
          } else {
            self?.showNotificationMessage(error.localizedDescription, error: true)
          }
        } else {
          let context = CoreDataStackManager.sharedInstance.newPrivateQueueContext()
          User.getUser(userId: User.currentUId, context: context, completion: nil)
          self?.saveUserId()
          self?.showMainView()
        }
      }
    }
  }

  func restoreSession() {
    if let userId = NSUserDefaults.standardUserDefaults().objectForKey(Constant.savedUserId) as? String {
      showLoadingActivity(text: "Restoring session...")
      User.currentUId = userId
      if isOnline() {
        User.getUser(userId: User.currentUId, context: CoreDataStackManager.sharedInstance.newPrivateQueueContext(), completion: nil)
      }
      performSelector(#selector(showMainView), withObject: nil, afterDelay: 1)
    }
  }

  func showMainView() {
    performSegueWithIdentifier("showMainView", sender: self)
  }

  func saveUserId() {
    NSUserDefaults.standardUserDefaults().setObject(User.currentUId, forKey: Constant.savedUserId)
    NSUserDefaults.standardUserDefaults().synchronize()
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
