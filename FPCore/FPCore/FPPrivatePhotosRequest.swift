//
//  FPPrivatePhotosRequest.swift
//  FPCore
//
//  Created by Simon Jensen on 23/03/17.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation

class FPPrivatePhotosRequest: FPRequest {
    public private(set) var user_id = "me"
    public private(set) var privacy_filter = "privacy_filter"
    public private(set) var auth_token: String!
    
    override init() {
        super.init()
        self.method = "flickr.photos.search"
    }
    
    override func exec(response: @escaping FPResponseHandler) {
        let token = FPCore.shared.token
        if token == nil {
            response(FPRequestError.InternalError, nil)
            return
        }
        
        self.auth_token = token!.authToken
        
        super.exec(response: response)
    }
}
