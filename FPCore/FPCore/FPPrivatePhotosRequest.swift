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
    public private(set) var privacy_filter = "5"
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
        return ""
    }
}
