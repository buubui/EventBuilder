//
//  HttpClient.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/16/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HttpClient: NSObject {
  static var sharedInstance = HttpClient()
  var manager = Alamofire.Manager()

  func cancelAll() {
    manager.session.invalidateAndCancel()
    manager = Alamofire.Manager()
  }

  func request(method: Alamofire.Method, url: URLStringConvertible, parameters: [String: AnyObject]?, completion: ((JSON?, NSError?) -> Void)) {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    let encoding: ParameterEncoding = method == .GET ? .URL : .JSON
    manager.request(method, url, parameters: parameters, encoding: encoding)
      .validate()
      .response { (request, response, data, error) in
        print(request?.URL?.absoluteString)
        print(parameters)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        if let data: AnyObject = data {
          let json = JSON(data: data as! NSData)
          if json.rawValue.isMemberOfClass(NSNull.self) {
            if let error = error {
              completion(nil, error)
            }
          } else {
            completion(json, nil)
          }
        }
    }
  }
}
