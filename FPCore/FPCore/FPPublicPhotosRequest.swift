//
//  FPPublicPhotosRequest.swift
//  FPCore
//
//  Created by Simon Jensen on 23/03/17.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation

public class FPPublicPhotosRequest: FPRequest {
    public override init()
    {
        super.init()
        
        self.endpoint = "https://api.flickr.com/services/feeds/photos_public.gne"
    }
    
    override func requestResponse(jsonObject: [String : Any]) throws -> (Any?) {
        print("Response json public")
        
        let items = jsonObject["items"] as! [[String: Any]]
        
        var photos: [FPPhoto] = []
        for item in items {
            if let photo = FPPhoto(json: item) {
                photos.append(photo)
            }
            
        }
        
        print(photos)
        
        return photos as! Any?
        
    }
    
}
