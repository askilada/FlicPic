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
    
    public init?(json: [String: Any]) {
        guard let title = json["title"] as? String,
            let author = json["author"] as? String,
            let authorId = json["author_id"] as? String,
            let dateTaken = json["date_taken"] as? String,
            let published = json["published"] as? String,
            let media = json["media"] as? [String: Any]
            else {
            return nil
        }
        
        self.title = title
        self.author = author
        self.authorId = authorId
        self.dateTaken = dateTaken
        self.published = published
        self.media = FPPhotoMedia(json: media)
        
        
    }
}

public struct FPPhotoMedia {
    var m:String!
    
    public init(json: [String: Any]) {
        self.m = json["m"] as? String
    }
}
