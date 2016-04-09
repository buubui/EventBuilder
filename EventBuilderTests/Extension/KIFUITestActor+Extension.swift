//
//  KIFUITestActor+Extension.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/7/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import KIF

extension KIFUITestActor {
  func assert(expression: BooleanType, _ message: String = "Assert failed") {
    runBlock { (errorPointer) -> KIFTestStepResult in
      if !expression.boolValue {
        errorPointer.memory =  NSError(domain: "KIFTest", code: Int(KIFTestStepResult.Failure.rawValue), userInfo: [NSLocalizedDescriptionKey : message])
        return .Failure
      }
      return .Success
    }
  }
}
