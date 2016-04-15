//
//  CoreDataStackManager.swift
//  VirtualTourist
//
//  Created by Buu Bui on 3/18/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStackManager {
// Multi-Context CoreData was setup follow this guide https://pawanpoudel.svbtle.com/fixing-core-data-concurrency-violations
  static var sharedInstance = CoreDataStackManager()

  func newPrivateQueueContext() -> NSManagedObjectContext {
    let privateQueueContext =
      NSManagedObjectContext(concurrencyType:
        .PrivateQueueConcurrencyType)
    privateQueueContext.parentContext = mainQueueContext
    privateQueueContext.mergePolicy =
    NSMergeByPropertyObjectTrumpMergePolicy
    return privateQueueContext
  }

  lazy var mainQueueContext: NSManagedObjectContext = {
    var mainQueueContext =
      NSManagedObjectContext(concurrencyType:
        .MainQueueConcurrencyType)
    mainQueueContext.parentContext = self.masterContext
    mainQueueContext.mergePolicy =
    NSMergeByPropertyObjectTrumpMergePolicy
    return mainQueueContext
  }()

  private lazy var masterContext: NSManagedObjectContext = {
    var masterContext =
      NSManagedObjectContext(concurrencyType:
        .PrivateQueueConcurrencyType)
    masterContext.persistentStoreCoordinator = self.persistentStoreCoordinator
    masterContext.mergePolicy =
    NSMergeByPropertyObjectTrumpMergePolicy
    return masterContext
  }()

  lazy var applicationDocumentsDirectory: NSURL = {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.buubui.VirtualTourist" in the application's documents Application Support directory.
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.count-1]
  }()

  lazy var managedObjectModel: NSManagedObjectModel = {
    // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
    let modelURL = NSBundle.mainBundle().URLForResource("EventBuilder", withExtension: "momd")!
    return NSManagedObjectModel(contentsOfURL: modelURL)!
  }()

  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
    // Create the coordinator and store
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(Constant.sqliteFileName)
    var failureReason = "There was an error creating or loading the application's saved data."
    do {
      try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
    } catch {
      // Report any error we got.
      var dict = [String: AnyObject]()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
      dict[NSLocalizedFailureReasonErrorKey] = failureReason

      dict[NSUnderlyingErrorKey] = error as NSError
      let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
      // Replace this with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
      abort()
    }

    return coordinator
  }()

  // MARK: - Core Data Saving support

  func saveContext () {
    if masterContext.hasChanges {
      do {
        try masterContext.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        abort()
      }
    }
  }
}
