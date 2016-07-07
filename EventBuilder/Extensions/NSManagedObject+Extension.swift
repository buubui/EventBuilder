//
//  NSManagedObject+Extension.swift
//  EventBuilder
//
//  Created by Buu Bui on 7/6/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
  func save() {
    guard let context = managedObjectContext else {
      return
    }
    context.saveRecursively()
  }
}
