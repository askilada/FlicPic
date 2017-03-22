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
    var params = Params()
    var ignore = ["endpoint", "secret"]
    var api_key: String
    var secret: String
    var format = "json"
    var nojsoncallback = "1"
    
    public init() {
        let core = FPCore.shared
        self.api_key = core.apiKey
        self.secret = core.apiSecret
    }
    
    public subscript (key:String) -> String {
        get {
            return self.params[key]! as! String
        }
        set {
            self.params[key] = newValue
        }
    }
    func addIgnore(_ property:String) {
        self.ignore.append(property)
    }
    func getChildren(children: Mirror.Children) -> Params {
        var p = Params()
        for child in children {
            let key = child.label!
            if(ignore.contains(key)) { continue }
            
            p[key] = child.value as? String
        }
        
        return p
    }
    
    
    
    public func exec() {
        let m = Mirror(reflecting: self)
        let props = getChildren(children: m.children)
        var requestProps:[String:String] = [:]
        
        if let ms = m.superclassMirror {
            let superProps = getChildren(children: ms.children)
            requestProps = superProps.mergeWith(dic: props)
        }
        
        var keys = Array(requestProps.keys).sorted { (s1, s2) -> Bool in
            if(s1.lowercased() < s2.lowercased())
            {
                return true
            }
            return false
        }
        
        let sorted = requestProps.sorted(by: {$0.0 < $1.0})
        var stringToSign = self.secret
        var finalQuery:[String] = []
        for (key, value) in sorted {
            stringToSign.append("\(key)\(value)")
            finalQuery.append("\(key)=\(value)")
        }
        
        print(stringToSign)
        var signed = FPCore.shared.sign.make(input: stringToSign)
        print(signed)
        finalQuery.append("api_sig=\(signed)")
        
        let query = finalQuery.joined(separator: "&")
        
        let url = NSURL(string: "\(self.endpoint)?\(query)")!
        print(url)
        
    }
    
}

public class FPAuthRequest: FPRequest {
    var mini_token: String
    
    public init(miniToken: String) {
        self.mini_token = miniToken
        super.init()
        self.method = "flickr.auth.getFullToken"
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
