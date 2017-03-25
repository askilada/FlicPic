//
//  FPMapPhoto.swift
//  FPCore
//
//  Created by Simon Jensen on 25/03/17.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation


public class FPMapPhoto: FPModel {
    public private(set) var title: String
    public private(set) var imageUrl: String
    public private(set) var lat: Decimal
    public private(set) var lon: Decimal
    public private(set) var owner: String
    
    public init?(title: String, imageUrl: String, lat: Decimal, lon: Decimal, owner: String) {
        self.title = title
        self.imageUrl = imageUrl
        self.lat = lat
        self.lon = lon
        self.owner = owner
    }
    
    public required init?(json: [String : Any]) {
        guard let title = json["title"] as? String
            , let imageUrl = json["url_s"] as? String
            , let lat = json["latitude"] as? Decimal
            , let lon = json["longitude"] as? Decimal
            , let owner = json["ownername"] as? String else {
                return nil
        }
        
        self.title = title
        self.imageUrl = imageUrl
        self.lat = lat
        self.lon = lon
        self.owner = owner
    }
}
