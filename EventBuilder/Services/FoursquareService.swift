//
//  FoursquareService.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/15/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit

class FoursquareService: NSObject {
  static var shareInstance = FoursquareService()

  func explore(query query: String?, latitude: Double, longitude: Double, completion: ((error: NSError?, data: [[String: AnyObject]]?) -> Void)?) {

    HttpClient.sharedInstance.request(.GET, url: Constant.Foursquare.exploreUrl, parameters: ["client_id": Constant.Foursquare.clientId, "client_secret": Constant.Foursquare.clientSecret, "ll": "\(latitude),\(longitude)","v": "20160418", "m": "foursquare"]) { json, error in
      if let error = error {
        completion?(error: error, data: nil)
        return
      }
      guard let json = json else {
        completion?(error: NSError.invalidDataError(), data: nil)
        return
      }
      print(json)
    }
  }
}
