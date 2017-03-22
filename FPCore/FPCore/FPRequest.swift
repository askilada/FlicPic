//
//  FCRequest.swift
//  FPCore
//
//  Created by Simon Jensen on 21/03/17.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation


public class FPRequest {
    public typealias Params = Dictionary<String, String>
    public var endpoint = "https://api.flickr.com/services/rest/"
    public var method = ""
    public var params = Params()
    
    public subscript (key:String) -> String {
        get {
            return self.params[key]!
        }
        set {
            self.params[key] = newValue
        }
    }
    
    
}

public class FPAuthRequest: FPRequest {
    var miniToken: String {
        get {
            return self["mini_token"]
        }
        set {
            self["mini_token"] = newValue
        }
    }
    
    
    init(miniToken:String) {
        super.init()
        self.miniToken = miniToken
        self.method = "flickr.auth.getFullToken"
        // self.addAllowd(["field1", "field2"])
    }
}


/*
public protocol FPRequest {
    var endpoint: String {get}
    var method: String {get}
    var auth: FPToken? {get set}
    func exec()
}

extension FPRequest {
    public func exec() {
        
        
        
        
        
        
    }
}

public class FCAuthRequest: FPRequest {
    public var auth: FPToken?
    public let endpoint: String = "https://api.flickr.com/services/rest/"
    public let method: String = "flickr.auth.getFullToken"
    public let mini_token: String
    public let nojsoncallback: Int = 1
    
    public init(miniToken:String) {
        self.mini_token = miniToken
    }
}
 */
