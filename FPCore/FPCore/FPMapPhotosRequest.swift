//
//  FPMapPhotosRequest.swift
//  FPCore
//
//  Created by Simon Jensen on 25/03/17.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation


public class FPMapPhotoRequest: FPRequest {
    
    public private(set) var lat: String
    public private(set) var lon: String
    public private(set) var extras: String = "date_upload,date_taken,owner_name,geo,url_sq,url_t,url_s,url_q,url_m,url_n,url_z,url_c,url_l,url_o"
    public private(set) var media:String = "photos"
    
    public init(lat: Double, lon: Double) {
        self.lat = String(lat)
        self.lon = String(lon)
        super.init()
        self.method = "flickr.photos.search"
        print("LOCA: \(lat) ; \(lon)")
    }
    
    override func requestResponse(jsonObject: [String : Any]) throws -> (Any?) {
        guard let data = jsonObject["photos"] as? [String: Any]
            , let photos = data["photo"] as? [[String: Any]] else {
                throw FPRequestError.InternalError
        }
        
        var p: [FPMapPhoto] = []
        for photo in photos {
            let np = FPMapPhoto(json: photo)
            if let np = np {
                p.append(np)
            } else {
                let keys = photo.keys
                print("KEYS: \(keys)")
            }
            
            
        }
        
        return p as Any?
        
    }
}
