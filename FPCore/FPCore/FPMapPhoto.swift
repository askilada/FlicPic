//
//  FPMapPhoto.swift
//  FPCore
//
//  Created by Simon Jensen on 25/03/17.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation


public class FPMapPhoto: FPModel, FPImageModel {
    public private(set) var title: String!
    public private(set) var imageUrl: String
    public private(set) var lat: Double
    public private(set) var lon: Double
    public private(set) var owner: String
    public private(set) var bigImageUrl: String?
    public private(set) var mediumImageUrl: String?
    public private(set) var smallImageUrl: String?
    
    public init?(title: String, imageUrl: String, lat: Double, lon: Double, owner: String) {
        self.title = title
        self.imageUrl = imageUrl
        self.lat = lat
        self.lon = lon
        self.owner = owner
    }
    
    public required init?(json: [String : Any]) {
        guard let title = json["title"] as? String
            , let imageUrl = json["url_s"] as? String
            , let owner = json["ownername"] as? String else {
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
        self.owner = owner
    }
    
    public func getImageURL() -> URL {
        return URL(string: self.imageUrl)!
    }
    
    public func getImage(type: ImageType, _ responseHandler: @escaping FPImageModel.FPImageResponse) {
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
                responseHandler(FPRequestError.InternalError, nil)
                return
            }
            break;
        }
        
        let url = URL(string: imageURLStr)!
        
        loadImageFromURL(url, withResponseHandler: responseHandler)
        return
    
    }
    

    
}
