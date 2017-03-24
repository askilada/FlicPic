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
        print(jsonObject)
        if let stat = jsonObject["stat"] as? String, let msg = jsonObject["message"] as? String, stat == "fail" {
            print(msg)
            throw FPRequestError.WrongMiniToken
        }
        
        
        
        guard let auth = jsonObject["auth"] as? [String:Any]
            , let user = auth["user"] as? [String:String]
            , let token = auth["token"] as? [String:String] else {
            throw FPRequestError.InternalError
        }
        
        
        let t = FPToken(authToken: token["_content"]!, userId: user["nsid"]!, userName: user["username"]!)
        FPCore.shared.token = t
        
        return token
    }
}
