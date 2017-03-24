//
//  FPPhoto.swift
//  FPCore
//
//  Created by Simon Jensen on 23/03/2017.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation

public protocol FPModel {
    init?(json: [String: Any])
}

public class FPPhoto: FPModel {
    public private(set) var title:String!
    public private(set) var author:String!
    public private(set) var authorId:String!
    public private(set) var dateTaken:String!
    public private(set) var published: String!
    public private(set) var media: FPPhotoMedia!
    
    public required init?(json: [String: Any]) {
        guard let title = json["title"] as? String else {
            return nil
        }
        
        // Media part
        if let media = json["media"] as? [String: Any] {
            self.media = FPPhotoMedia(json: media)
        } else if let media = json["url_s"] as? String {
            self.media = FPPhotoMedia(json: ["m": media])
        } else {
            return nil
        }
        
        // Author part
        if let author = json["author"] as? String {
            self.author = author
        } else if let author = json["ownername"] as? String {
            self.author = author
        }
        
        // Author Id
        if let authorId = json["author_id"] as? String {
            self.authorId = authorId
        } else if let authorId = json["owner"] as? String {
            self.authorId = authorId
        } else {
            return nil
        }
        
        // Published
        if let published = json["published"] as? String {
            self.published = published
        } else if let published = json["dateupload"] as? String {
            self.published = published
        } else {
            return nil
        }
        
        // Date Taken
        if let dateTaken = json["date_taken"] as? String {
            self.dateTaken = dateTaken
        } else if let dateTaken = json["datetaken"] as? String {
            self.dateTaken = dateTaken
        } else {
            return nil
        }

        print(json["url_l"] as? String)
        
        self.title = title
    }
}

public struct FPPhotoMedia {
    public private(set) var m:String!
    
    public init(json: [String: Any]) {
        self.m = json["m"] as? String
    }
}
