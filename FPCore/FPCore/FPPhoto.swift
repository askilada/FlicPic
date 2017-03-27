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

public protocol FPImageModel {
    typealias FPImageResponse = (Error?, UIImage?) -> Void
    var title: String! {get}
    func getImageURL() -> URL
    func getImage(type: ImageType, _ responseHandler: FPImageResponse)
    func loadImageFromURL(_ url: URL, withResponseHandler responseHandler: @escaping FPImageResponse)
}

public extension FPImageModel {
    func loadImageFromURL(_ url: URL, withResponseHandler responseHandler: @escaping FPImageResponse) {
        let req = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 2)
        
        URLSession.shared.dataTask(with: req) { (data, urlresponse, error) in
            if let error = error {
                responseHandler(error, nil)
                return
            }
            
            let image = UIImage(data: data!)
            responseHandler(nil, image)
        }
        
    }
}

public enum ImageType {
    case big
    case small
    case medium
}

public class FPPhoto: FPModel, FPImageModel {
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
    
    public func getImageURL() -> URL {
        return URL(string: self.media.m)!
    }

    public func getImage(type: ImageType, _ responseHandler: (Error?, UIImage?) -> Void) {
        
    }
    
    
}

public struct FPPhotoMedia {
    public private(set) var m:String!
    
    public init(json: [String: Any]) {
        self.m = json["m"] as? String
    }
}
