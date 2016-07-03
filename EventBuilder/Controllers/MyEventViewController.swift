//
//  MyEventViewController.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/7/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import FlatUIKit

class MyEventViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!

  var data =  [String: AnyObject]()
  var keys = [String]()
  var receivedKeys = [String]()

  class func instantiateStoryboard() -> MyEventViewController {
    return UIStoryboard.mainStoryBoard.instantiateViewControllerWithIdentifier("MyEventViewController") as! MyEventViewController
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
    tableView.emptyDataSetSource = self
    tableView.emptyDataSetDelegate = self
    setupRootViewController()
    reload()
  }

  func reload() {
    var receivedFirst = false
    FirebaseService.shareInstance.getMyEvents(User.currentUId) { (keys, receivedEventDict, receivedEventId) in
      if !receivedFirst {
        self.keys = keys
        receivedFirst = true
      }
      self.data[receivedEventId] = receivedEventDict
      self.receivedKeys.append(receivedEventId)
      self.tableView.reloadData()
    }
  }

  func itemAtIndex(index: Int) -> AnyObject? {
    let key = receivedKeys[index]
    return data[key]
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let item = sender as? [String: AnyObject], controller =  segue.destinationViewController as? EventDetailsViewController where segue.identifier == "showEventDetails"  {
      controller.event = item
    }
  }
}

extension MyEventViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return receivedKeys.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("EventCell")!
    let item = itemAtIndex(indexPath.row)!
    cell.textLabel?.text = item["name"] as? String
    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let item = itemAtIndex(indexPath.row)!
    performSegueWithIdentifier("showEventDetails", sender: item)
  }
}

extension MyEventViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
  func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
    return StyleKit.imageOfCalendar(frame: CGRect(x: 0, y:0, width: 200, height: 200), calendarColor: UIColor.flatWhiteColor(), wandColor: UIColor.flatWhiteColor())
  }

  func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
    return NSAttributedString(string: "No Event", attributes: [NSForegroundColorAttributeName: UIColor(red: 0.929, green: 0.945, blue: 0.949, alpha: 1)])
  }

}