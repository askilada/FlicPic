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
    let apiKey = ""
    let apiSecret = ""
    let authUrl = "https://www.flickr.com/auth-72157678250365384"
    public var sign: FPMD5Hash!
    
}
