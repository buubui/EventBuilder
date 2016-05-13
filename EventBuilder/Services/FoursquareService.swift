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

    var params = [
      "client_id": Constant.Foursquare.clientId,
      "client_secret": Constant.Foursquare.clientSecret,
      "ll": "\(latitude),\(longitude)",
      "v": "20160418",
      "m": "foursquare"]
    if let query = query {
      params["query"] = query
    }

    HttpClient.sharedInstance.request(.GET, url: Constant.Foursquare.exploreUrl, parameters: params) { json, error in
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

  func search(query query: String?, latitude: Double, longitude: Double, completion: ((error: NSError?, data: [FQVenue]?) -> Void)?) {
    var params = [
      "client_id": Constant.Foursquare.clientId,
      "client_secret": Constant.Foursquare.clientSecret,
      "ll": "\(latitude),\(longitude)",
      "v": "20160418",
      "m": "foursquare"]
    if let query = query {
      params["query"] = query
    }
    HttpClient.sharedInstance.request(.GET, url: Constant.Foursquare.searchUrl, parameters: params) { json, error in
      if let error = error {
        completion?(error: error, data: nil)
        return
      }
      guard let json = json else {
        completion?(error: NSError.invalidDataError(), data: nil)
        return
      }
      print(json)
      guard let response = json.dictionaryObject?["response"] as? [String: AnyObject], venueList = response["venues"] as? [[String: AnyObject]] else {
        return
      }
      var results = [FQVenue]()
      for venueDict in venueList {
        if let venture = FQVenue(dictionary: venueDict) {
          results.append(venture)
        }
      }
      completion?(error: nil, data: results)
    }
  }
}
