//
//  FPMapPhoto.swift
//  FPCore
//
//  Created by Simon Jensen on 25/03/17.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation


public class FPMapPhoto: FPModel, FPImageModel {
    public private(set) var title: String
    public private(set) var author: String
    public private(set) var authorId: String
    
    
    public private(set) var imageUrl: String
    public private(set) var lat: Double
    public private(set) var lon: Double
    
    
    public private(set) var bigImageUrl: String?
    public private(set) var mediumImageUrl: String?
    public private(set) var smallImageUrl: String?
    
    /*
    public init?(title: String, imageUrl: String, lat: Double, lon: Double, owner: String) {
        self.title = title
        self.imageUrl = imageUrl
        self.lat = lat
        self.lon = lon
    }
    */
    
    public required init?(json: [String : Any]) {
        guard let title = json["title"] as? String
            , let imageUrl = json["url_s"] as? String
            , let author = json["ownername"] as? String
            , let authorId = json["owner"] as? String else {
                return nil
        }
        
        self.bigImageUrl = json["url_l"] as? String
        self.mediumImageUrl = json["url_m"] as? String
        self.smallImageUrl = json["url_s"] as? String
        
        // Latitude
        if let lat = json["latitude"] as? Double {
            self.lat = lat
        } else if let lat = json["latitude"] as? String {
            self.lat = Double(lat)!
        } else {
            return nil
        }
        
        // Longitude
        if let lon = json["longitude"] as? Double {
            self.lon = lon
        } else if let lon = json["longitude"] as? String {
            self.lon = Double(lon)!
        } else {
            return nil
        }
        
        self.title = title
        self.imageUrl = imageUrl
        self.author = author
        self.authorId = authorId
    }
    
    public func getImageURL() -> URL {
        return URL(string: self.imageUrl)!
    }


    

    
}
