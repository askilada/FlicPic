//
//  FPCore.swift
//  FPCore
//
//  Created by Simon Jensen on 21/03/17.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation


public struct FPToken {
    public var authToken:String
    public var userId:String
    public var userName:String
    
}

public enum FPEndpoint {
    case Authenticate
}

public protocol FPMD5Hash {
    func make(input:String) -> String
}

public class FPCore {
    public static let shared: FPCore = FPCore();
    let apiKey = FPConfig.apiKey
    let apiSecret = FPConfig.apiSecret
    public let authUrl = "https://www.flickr.com/auth-72157678250365384" 
    public var sign: FPMD5Hash!
    public var token: FPToken? {
        didSet {
            self.store(token: token, inDefaults: UserDefaults.standard)
        }
    }
    
    init() {
        if let token = UserDefaults.standard.string(forKey: "token")
            , let userId = UserDefaults.standard.string(forKey: "userId")
            , let userName = UserDefaults.standard.string(forKey: "userName") {
            
            let t = FPToken(authToken: token, userId: userId, userName: userName)
            self.token = t
        }
        
    }
    
    func store(token: FPToken?, inDefaults defaults: UserDefaults) {
        if let token = token {
            defaults.set(token.authToken, forKey: "token")
            defaults.set(token.userId, forKey: "userId")
            defaults.set(token.userName, forKey: "userName")
        } else {
            defaults.removeObject(forKey: "token")
            defaults.removeObject(forKey: "userId")
            defaults.removeObject(forKey: "userName")
        }
        
    }
    
    
    
    
    
}
