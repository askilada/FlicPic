//: Playground - noun: a place where people can play

import UIKit
import FPCore

let json:[String: Any] = [
    "type": "photo",
    "id": 1234
]



let s = FPUserActivity(json: json)
