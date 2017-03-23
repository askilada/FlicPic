//
//  FPAuthRequest.swift
//  FPCore
//
//  Created by Simon Jensen on 23/03/17.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation

public class FPAuthRequest: FPRequest {
    var mini_token: String
    
    public init(miniToken: String) {
        self.mini_token = miniToken
        super.init()
        self.method = "flickr.auth.getFullToken"
    }
    
    
    override func requestResponse(jsonObject: [String : Any]) throws -> (Any?) {
        
        guard let auth = jsonObject["auth"] as? [String:String]
            , let user = jsonObject["user"] as? [String:String] else {
            throw FPRequestError.InternalError
        }
        
        
        let token = FPToken(authToken: auth["_content"]!, userId: user["nsid"]!, userName: user["username"]!)
        FPCore.shared.token = token
        
        return token
    }
}
