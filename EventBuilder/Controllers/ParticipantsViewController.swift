//
//  ParticipantsViewController.swift
//  EventBuilder
//
//  Created by Buu Bui on 7/1/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit

class ParticipantsViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var event: [String: AnyObject]!
  var data =  [String: AnyObject]()
  var keys = [String]()
  var receiveKeys = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
    reload()
  }

  func reload() {
    var receivedFirst = false
    FirebaseService.shareInstance.getParticipantsOfEventId(event["uId"] as! String) { keys, receivedDict, receivedUid in
      if !receivedFirst {
        self.keys = keys
        receivedFirst = true
      }
      self.data[receivedUid] = receivedDict
      self.receiveKeys.append(receivedUid)
      self.tableView.reloadData()
    }
  }

  @IBAction func doneButtonDidTap(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}

extension ParticipantsViewController: UITableViewDelegate, UITableViewDataSource {

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return receiveKeys.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ParticipantCell")!
    let key = receiveKeys[indexPath.row]
    let participant = data[key]!
    cell.textLabel?.text = participant["name"] as? String

    return cell
  }
}
