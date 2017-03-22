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

public class FPCore {
    public static let shared: FPCore = FPCore();
    let apiKey = "3f5d55a13807a363e539fa157affdc74"
    let apiSecret = "a468ca3c91577070"
    let authUrl = "https://www.flickr.com/auth-72157678250365384"
        
    
}
