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
    func getImageURL() -> URL
    func getImage(type: ImageType, _ responseHandler: @escaping FPImageResponse)
    func loadImageFromURL(_ url: URL, withResponseHandler responseHandler: @escaping FPImageResponse)
    
    var title:String {get}
    var author:String {get}
    var authorId:String {get}
    
    var bigImageUrl: String? {get}
    var mediumImageUrl: String? {get}
    var smallImageUrl: String? {get}

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
        }.resume()
        
    }
    
    public func getImage(type: ImageType, _ responseHandler: @escaping (Error?, UIImage?) -> Void) {
        var imageURLStr: String!
        switch type {
        case .big:
            if let big = self.bigImageUrl {
                imageURLStr = big
            } else {
                self.getImage(type: .medium, responseHandler)
                return
            }
            break;
        case .medium:
            if let med = self.mediumImageUrl {
                imageURLStr = med
            } else {
                self.getImage(type: .small, responseHandler)
                return
            }
            break
        case .small:
            if let small = self.smallImageUrl {
                imageURLStr = small
            } else {
                responseHandler(FPPhotoError.noPhotoFound, nil)
                return
            }
            break;
        }
        
        print("Image loaded: ")
        print(type)
        
        
        if let url = URL(string: imageURLStr) {
            loadImageFromURL(url, withResponseHandler: responseHandler)
            return
        }
        
        
        responseHandler(FPPhotoError.noPhotoFound, nil)
        
        return
        
    }
}

public enum ImageType {
    case big
    case small
    case medium
}

public enum FPPhotoError: Error {
    case noPhotoFound
    case createError
}

public class FPPhoto: FPModel, FPImageModel {
    public private(set) var title: String
    public private(set) var author: String
    public private(set) var authorId: String


    public private(set) var dateTaken:String!
    public private(set) var published: String!
    
    public private(set) var bigImageUrl: String?
    public private(set) var mediumImageUrl: String?
    public private(set) var smallImageUrl: String?
    
    public required init?(json: [String: Any]) {
        guard let title = json["title"] as? String else {
            return nil
        }
        
        self.smallImageUrl = json["url_s"] as? String
        self.mediumImageUrl = json["url_m"] as? String
        self.bigImageUrl = json["url_l"] as? String
        
        // Author part
        if let author = json["author"] as? String {
            self.author = author
        } else if let author = json["ownername"] as? String {
            self.author = author
        } else {
            return nil
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

        
        self.title = title
    }
    
    public func getImageURL() -> URL {
        return URL(string: self.mediumImageUrl!)!
    }
    
    
}

public struct FPPhotoMedia {
    public private(set) var m:String!
    
    public init(json: [String: Any]) {
        self.m = json["m"] as? String
    }
}
