//
//  FPMapPhotosRequest.swift
//  FPCore
//
//  Created by Simon Jensen on 25/03/17.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation


public class FPMapPhotoRequest: FPRequest {
    
    public private(set) var lat: Double
    public private(set) var lon: Double
    public private(set) var extras: String = "date_upload,date_taken,owner_name,geo,url_sq,url_t,url_s,url_q,url_m,url_n,url_z,url_c,url_l,url_o"
    
    public init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
        super.init()
        self.method = "flickr.photos.getRecent"
    }
    
    override func requestResponse(jsonObject: [String : Any]) throws -> (Any?) {
        print(jsonObject.keys)
        guard let data = jsonObject["photos"] as? [String: Any]
            , let photos = data["photo"] as? [[String: Any]] else {
                throw FPRequestError.InternalError
        }
        
        var p: [FPMapPhoto] = []
        for photo in photos {
            if let np = FPMapPhoto(json: photo) {
                p.append(np)
            }
        }
        
        return p as Any?
        
    }
}
