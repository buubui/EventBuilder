//
//  TestConstant.swift
//  EventBuilder
//
//  Created by Buu Bui on 4/9/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit

struct TestConstant {
  static let email = "tester@udacity.com"
  static let password = "password"
  static let testFireBaseData: [String: AnyObject] =
    [
      "events" : [
        "-KMKwyNI9OX9mHAMJJTE" : [
          "creator" : "5e633100-63ab-45e9-a833-62e89610397c",
          "details" : "Current Event Description",
          "endDate" : 1472320534,
          "name" : "Current Test Event",
          "participants" : [
            "5e633100-63ab-45e9-a833-62e89610397c" : true,
            "ehK0DNcGHvYVESsngrM97YqRGxA2" : true
          ],
          "place" : [
            "address" : "68 Regent St",
            "city" : "London",
            "id" : "50c070d7e4b06f3d184f48ce",
            "latitude" : 51.51018832877561,
            "longitude" : -0.1360968182179,
            "name" : "Café Royal Hotel"
          ],
          "startDate" : 1468173394
        ],
        "-KMKxGEcg20XjCO3pXQS" : [
          "creator" : "5e633100-63ab-45e9-a833-62e89610397c",
          "details" : "Upcoming Event Description",
          "endDate" : 1475085420,
          "name" : "Upcoming Test Event",
          "participants" : [
            "5e633100-63ab-45e9-a833-62e89610397c" : true
          ],
          "place" : [
            "address" : "3-4 Rupert Ct.",
            "city" : "Chinatown",
            "id" : "4afc9a04f964a5204c2422e3",
            "latitude" : 51.51118638615311,
            "longitude" : -0.1325815916061401,
            "name" : "C&R Café Restaurant | 馬來一哥"
          ],
          "startDate" : 1471024620
        ],
        "-KMKxYDy9-kXfj0WiuGn" : [
          "creator" : "5e633100-63ab-45e9-a833-62e89610397c",
          "details" : "Past Event Description",
          "endDate" : 1468173551,
          "name" : "Past Test Event",
          "participants" : [
            "5e633100-63ab-45e9-a833-62e89610397c" : true,
            "ehK0DNcGHvYVESsngrM97YqRGxA2" : true
          ],
          "place" : [
            "address" : "3 Macclesfield St",
            "city" : "Chinatown",
            "id" : "4b8ff84af964a5201e6d33e3",
            "latitude" : 51.51195000359161,
            "longitude" : -0.1312083172877174,
            "name" : "Candy Café"
          ],
          "startDate" : 1468173491
        ]
      ],
      "profiles" : [
        "5e633100-63ab-45e9-a833-62e89610397c" : [
          "email" : "tester@udacity.com",
          "events" : [
            "-KMKwyNI9OX9mHAMJJTE" : true,
            "-KMKxGEcg20XjCO3pXQS" : true,
            "-KMKxYDy9-kXfj0WiuGn" : true
          ],
          "imageUrl" : "https://firebasestorage.googleapis.com/v0/b/udacitycapstonetest.appspot.com/o/users%2F5e633100-63ab-45e9-a833-62e89610397c.jpg?alt=media&token=c1d8467f-da4f-48ef-b4c5-5799f1a03209",
          "name" : "Tester",
          "phone" : "123 123 123"
        ],
        "ehK0DNcGHvYVESsngrM97YqRGxA2" : [
          "email" : "tester2@udacity.com",
          "events" : [
            "-KMKwyNI9OX9mHAMJJTE" : true,
            "-KMKxYDy9-kXfj0WiuGn" : true
          ],
          "imageUrl" : "https://firebasestorage.googleapis.com/v0/b/udacitycapstonetest.appspot.com/o/users%2FehK0DNcGHvYVESsngrM97YqRGxA2.jpg?alt=media&token=a1005581-ca50-444f-ab74-a8ebbe76194f",
          "name" : "Tester 2",
          "phone" : "4645645234"
        ]
      ]
  ]
}
