//
//  NSManagedObjectContext+Extension.swift
//  VirtualTourist
//
//  Created by Buu Bui on 3/27/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
  func saveRecursively() {
    performBlockAndWait {
      if self.hasChanges {
        self.saveThisAndParentContexts()
      }
    }
  }

  func saveThisAndParentContexts() {
    do {
      try save()
      parentContext?.saveRecursively()
    } catch {
      print("saveThisAndParentContexts: \(error)")

    }
  }
}
