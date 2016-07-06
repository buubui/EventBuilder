//
//  Constant.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/5/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit

struct Constant {
  static let sqliteFileName = "EventBuilder.sqlite"
  static let defaultProfilePicture = "sample_profile_picture"
  static let locationDistanceFilter = 100.0

  struct Notification {
    static let didSignOut = "didSignOutNotification"
    static let didChangeUserObject = "didChangeUserObject"
  }

  struct Firebase {
    static var baseUrl: String {
      if Helper.isTestMode() {
        return "https://udacitycapstonetest.firebaseio.com"
      }
      return "https://popping-torch-3350.firebaseio.com"
    }
    static var storageUrl: String {
      if Helper.isTestMode() {
        return "gs://udacitycapstonetest.appspot.com"
      }
      return "gs://popping-torch-3350.appspot.com"
    }
    static var baseTestUrl = "https://udacitycapstonetest.firebaseio.com"
    static let profiles = "profiles"
    static let events = "events"
    static let places = "places"
    static let participants = "participants"
  }

  struct Foursquare {
    static let clientId = "A4FAXPDG3HGQRLRMF4TRBPJLUNWGSW30FQZJQZPQNPVUGZ4I"
    static let clientSecret = "DI0S43SU324RWRIY3YVRGPCHX4CCGHZDPNXCLAHZM55BKNSZ"
    
    static let baseUrl = "https://api.foursquare.com/v2"
    static let exploreUrl = "\(baseUrl)/venues/explore"
    static let searchUrl = "\(baseUrl)/venues/search"
  }

  struct Wunderground {
    static let apiKey = "1f7a5ff12079d1bd"
  }
}
