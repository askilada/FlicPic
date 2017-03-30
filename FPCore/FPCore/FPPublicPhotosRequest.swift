//
//  FPPublicPhotosRequest.swift
//  FPCore
//
//  Created by Simon Jensen on 23/03/17.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation

public class FPPublicPhotosRequest: FPRequest {
    let media = "photos"
    let extras = "url_sq,url_t,url_s,url_q,url_m,url_n,url_z,url_c,url_l,url_o,owner_name,date_taken,date_upload"
    
    public override init()
    {
        super.init()
        
        self.method = "flickr.photos.search"
    }
    
    override func requestResponse(jsonObject: [String : Any]) throws -> (Any?) {
        print("Response json public")
        
        guard let data = jsonObject["photos"] as? [String: Any]
        , let photos = data["photo"] as? [[String: Any]] else {
            
            throw FPPhotoError.createError
        }
        
        
        
        var p: [FPPhoto] = []
        for item in photos {
            if let photo = FPPhoto(json: item) {
                p.append(photo)
            }
            
        }
        
        print(p)
        
        return p as Any?
        
    }
    
}
