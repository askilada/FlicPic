//
//  FPPrivatePhotosRequest.swift
//  FPCore
//
//  Created by Simon Jensen on 23/03/17.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation

public class FPPrivatePhotosRequest: FPRequest {
    public private(set) var user_id = "me"
    public private(set) var extras = "url_sq,url_t,url_s,url_q,url_m,url_n,url_z,url_c,url_l,url_o,owner_name,date_taken,date_upload"
    public private(set) var auth_token: String!
    
    override public init() {
        super.init()
        self.method = "flickr.photos.search"
        
    }
    
    override public func exec(response: @escaping FPResponseHandler) {
        let token = FPCore.shared.token
        if token == nil {
            response(FPRequestError.InternalError, nil)
            return
        }
        
        self.auth_token = token!.authToken
        
        super.exec(response: response)
    }
    
    override func requestResponse(jsonObject: [String : Any]) throws -> (Any?) {
        
        guard let data = jsonObject["photos"] as? [String: Any]
            , let photos = data["photo"] as? [[String: Any]] else {
            throw FPRequestError.InternalError
        }
        
        let p = photos.map { (photo) -> FPPhoto in
            let f = FPPhoto(json: photo)
            return f!
        }
        
        return p as! Any?
        
        
        
        
    }
}
