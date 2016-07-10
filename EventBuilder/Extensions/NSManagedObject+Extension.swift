//
//  NSManagedObject+Extension.swift
//  EventBuilder
//
//  Created by Buu Bui on 7/6/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension NSManagedObject {
  var saveNotificationName: String {
    return "NSManagedObjectDidSave"
  }
  func save() {
    guard let context = managedObjectContext else {

      return
    }

    context.saveRecursively()

    NSNotificationCenter.defaultCenter().postNotificationName(saveNotificationName, object: self)
  }
}
