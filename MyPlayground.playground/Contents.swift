//: Playground - noun: a place where people can play

import UIKit
import FPCore


let photo = FPMapPhoto(title: "Nice", imageUrl: "", lat: 37.799999999999997, lon: 43.123123, owner: "ME")!

let lat = (photo.lat * 10 ).rounded() / 10