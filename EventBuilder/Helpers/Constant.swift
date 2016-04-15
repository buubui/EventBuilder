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
  static var firebaseUrl: String {
    if Helper.isTestMode() {
      return "https://udacitycapstonetest.firebaseio.com"
    }
    return "https://popping-torch-3350.firebaseio.com"
  }
  static let foursquareClientId = "A4FAXPDG3HGQRLRMF4TRBPJLUNWGSW30FQZJQZPQNPVUGZ4I"
  static let foursquareClientSecret = "DI0S43SU324RWRIY3YVRGPCHX4CCGHZDPNXCLAHZM55BKNSZ"

  struct Notification {
    static let didSignOut = "didSignOutNotification"
    static let didChangeUserObject = "didChangeUserObject"
  }

  struct Firebase {
    static let profiles = "profiles"
    static let events = "events"
    static let places = "places"
  }
}
