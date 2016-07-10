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
  @IBOutlet weak var tabControl: FUISegmentedControl!

  var data =  MyEvents()

  private var activeTab = EventTimeType.Current {
    didSet {
      tableView.reloadData()
    }
  }
  private var timer: NSTimer?

  class func instantiateStoryboard() -> MyEventViewController {
    return UIStoryboard.mainStoryBoard.instantiateViewControllerWithIdentifier("MyEventViewController") as! MyEventViewController
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
    setupUI()
    tabControl.selectedSegmentIndex = activeTab.rawValue
    tableView.emptyDataSetSource = self
    tableView.emptyDataSetDelegate = self
    setupRootViewController()
    loadEventsFromDatabase()
    reload()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didCreateEvent(_:)), name: Constant.Notification.didCreateEvent, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reload), name: Constant.Notification.didAttendEvent, object: nil)
  }

  func setupUI() {
    tabControl.selectedFont = UIFont.boldFlatFontOfSize(14)
    tabControl.selectedFontColor = UIColor.pomegranateColor()
    tabControl.deselectedFont = UIFont.flatFontOfSize(14)
    tabControl.deselectedFontColor = UIColor.flatWhiteColor()
    tabControl.selectedColor = UIColor.flatWhiteColor()
    tabControl.deselectedColor = UIColor.pomegranateColor()
    tabControl.dividerColor = UIColor.flatWhiteColor()
    tabControl.cornerRadius = 4.0
    tabControl.borderColor = UIColor.flatWhiteColor()
    tabControl.borderWidth = 1.0
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if self.timer == nil {
      self.timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(reCategorize), userInfo: nil, repeats: true)
    }
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    if let timer = timer {
      timer.invalidate()
      self.timer = nil
    }
  }

  func loadEventsFromDatabase() {
    if let user = User.currentUser(), events = user.events?.allObjects as? [Event] {
      for event in events {
        self.data.addEvent(event)
      }
    }
  }

  func reload() {
    guard let user = User.currentUser() where isOnline() else {
      return
    }

    var firstItem = false
    user.getMyEvents { keys, receivedEvent in
      if !firstItem {
        firstItem = true
        self.data.removeAll()
      }
      if self.data.addEvent(receivedEvent) != nil {
      }
      self.tableView.reloadData()
    }
  }

  func reCategorize() {
    data.reCategorize()
    tableView.reloadData()
  }

  func itemAtIndex(index: Int) -> Event? {
    return data.eventAtIndex(index, timeType: activeTab)
  }

  @IBAction func reloadButtonDidTap(sender: UIBarButtonItem) {
    if !isOnline() {
      showNotificationMessage("Cannot perform this function in offline mode, please check the internet connection.", error: true)
      return
    }
    reload()
  }

  @IBAction func tabDidChange(sender: FUISegmentedControl) {
    activeTab = EventTimeType(rawValue: sender.selectedSegmentIndex)!
  }

  func didCreateEvent(notification: NSNotification) {
    guard let event = notification.object as? Event else { return }
    if data.addEvent(event) == activeTab {
      tableView.reloadData()
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let item = sender as? Event, controller =  segue.destinationViewController as? EventDetailsViewController where segue.identifier == "showEventDetails"  {
      controller.event = item
    }
  }

  override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
    if identifier == "showAddNewEvent" && !isOnline() {
      showNotificationMessage("Cannot create new event in offline mode, please check the internet connection.", error: true)
      return false
    }
    return true
  }
}

extension MyEventViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.numberOfEvents(timeType: activeTab)
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("EventCell")!
    let item = itemAtIndex(indexPath.row)!
    cell.textLabel?.text = item.name
    cell.detailTextLabel?.text = item.fullDateRangeString()
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
    return NSAttributedString(string: "No \(activeTab.title) Event", attributes: [NSForegroundColorAttributeName: UIColor(red: 0.929, green: 0.945, blue: 0.949, alpha: 1)])
  }
}

extension MyEventViewController {
  class MyEvents {
    var events = [String: Event]()
    var currentEvents = [String]()
    var upcomingEvents = [String]()
    var pastEvents = [String]()

    func numberOfEvents(timeType timeType: EventTimeType) -> Int {
      switch timeType {
      case .Current:
        return currentEvents.count
      case .Upcoming:
        return upcomingEvents.count
      case .Past:
        return pastEvents.count
      }
    }

    func eventAtIndex(index: Int, timeType: EventTimeType) -> Event? {
      let list = { () -> [String] in
        switch timeType {
        case .Current:
          return currentEvents
        case .Upcoming:
          return upcomingEvents
        case .Past:
          return pastEvents
        }
      }()

      let key = list[index]

      return events[key]
    }

    func addEvent(event: Event) -> EventTimeType? {
      guard let id = event.id, type = event.timeType else { return nil }

      if categorizeEvent(event) {
        events[id] = event
        return type
      }

      return nil
    }

    func categorizeEvent(event: Event) -> Bool {
      guard let id = event.id, type = event.timeType else { return false }

      switch type {
      case .Upcoming:
        upcomingEvents.append(id)
      case .Current:
        currentEvents.append(id)
      case .Past:
        pastEvents.append(id)
      }
      return true
    }

    func reCategorize() {
      currentEvents.removeAll()
      upcomingEvents.removeAll()
      pastEvents.removeAll()
      for event in events.values {
        categorizeEvent(event)
      }
    }

    func removeAll() {
      events.removeAll()
      currentEvents.removeAll()
      upcomingEvents.removeAll()
      pastEvents.removeAll()
    }
  }
}