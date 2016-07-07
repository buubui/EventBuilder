//
//  EditProfileViewController.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/12/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import Material
import ALCameraViewController
import Photos

class EditProfileViewController: UIViewController {

  var user: User!
  var shouldSave = false

  enum EditProfileRow: Int {
    case Name
    case Phone

    var description: String {
      switch self {
      case .Name: return "Name"
      case .Phone: return "Phone"
      }
    }
  }

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var profilePictureView: MaterialView!

  override func viewDidLoad() {
    super.viewDidLoad()
    profilePictureView.image = user.image ?? UIImage.defaultProfilePicture()
    tableView.tableFooterView = UIView()
  }

  @IBAction func cancelButtonDidTap(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  func save() {
    showLoadingActivity(text: "Updating...")
    user.updateFirebase { [weak self] error in
      defer {
        self?.hideLoadingActivity()
      }
      if let error = error {
        self?.showNotificationMessage(error.localizedDescription, error: true)
        return
      }
      self?.user.save()
      self?.dismissViewControllerAnimated(true, completion: nil)
    }
  }

  @IBAction func saveButtonDidTap(sender: UIBarButtonItem) {
    view.endEditing(true)
    NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(EditProfileViewController.save), userInfo: nil, repeats: false)
  }

  @IBAction func changeProfilePictureDidTap(sender: UIButton) {

    let imagePickerCompletion = {[weak self] (image: UIImage?, asset: PHAsset?) in
      runInMainThread {
        if let image = image {
          self?.profilePictureView.image = image
          self?.user.image = image
        }
        self?.dismissViewControllerAnimated(true, completion: nil)
      }
    }

    let cameraAction = (title: "Camera", action: { [weak self] in
      let controller = CameraViewController(croppingEnabled: true, allowsLibraryAccess: true, completion: imagePickerCompletion)
      runInMainThread {
        self?.presentViewController(controller, animated: true, completion: nil)
      }
    })

    let galleryAction = (title: "Gallery", action: { [weak self] in
      let controller = CameraViewController.imagePickerViewController(true, completion: imagePickerCompletion)
      runInMainThread {
        self?.presentViewController(controller, animated: true, completion: nil)
      }
    })

    showActionSheet(message: "Change Profile Picture", actions: [cameraAction, galleryAction])
  }
}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("EditableProfileCell") as! EditableTableViewCell
    cell
    guard let row = EditProfileRow(rawValue: indexPath.row) else {
      return cell
    }

    switch row {
    case .Name:
      cell.headingLabel.text = "Name"
      cell.inputTextField.text = user.name
    case .Phone:
      cell.headingLabel.text = "Phone"
      cell.inputTextField.text = user.phone
    }
    cell.inputTextField.tag = row.rawValue
    cell.inputTextField.accessibilityLabel = "EditProfile - \(row.description)Field"
    cell.inputTextField.delegate = self
    return cell
  }
}
extension EditProfileViewController: UITextFieldDelegate {

  func textFieldDidEndEditing(textField: UITextField) {
    guard let row = EditProfileRow(rawValue: textField.tag), context = user.managedObjectContext else {
      return
    }
    context.performBlockAndWait {
      switch row {
      case .Name:
        self.user.name = textField.text
      case .Phone:
        self.user.phone = textField.text
      }
//      if self.shouldSave {
//        self.shouldSave = false
//        self.save()
//      }
    }
  }
}
