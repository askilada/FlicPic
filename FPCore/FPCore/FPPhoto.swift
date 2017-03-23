//
//  FPPhoto.swift
//  FPCore
//
//  Created by Simon Jensen on 23/03/2017.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation

public class FPPhoto {
    var title:String!
    var author:String!
    var authorId:String!
    var dateTaken:String!
    var published: String!
    var media: FPPhotoMedia!
}

public struct FPPhotoMedia {
    var m:String!
}
