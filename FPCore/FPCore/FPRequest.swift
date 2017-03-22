//
//  FCRequest.swift
//  FPCore
//
//  Created by Simon Jensen on 21/03/17.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation

public typealias FPResponse = (Error?, Any?) -> Void

public enum FPRequestError: Error {
    case InternalError
}

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
    
    internal init() {
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
    
    public func makeParams() -> Params {
        let m = Mirror(reflecting: self)
        let props = getChildren(children: m.children)
        var requestProps:[String:String] = [:]
        
        if let ms = m.superclassMirror {
            let superProps = getChildren(children: ms.children)
            requestProps = superProps.mergeWith(dic: props)
        }
        
        return requestProps as Params
    }
    
    func paramsToString(_ params: Params) -> String{

        
        let sorted = params.sorted(by: {$0.0 < $1.0})
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
        
        return query
    }
    
    public func exec(response: FPResponse) {
        
        let params = makeParams()
        let query = paramsToString(params)
        
        let url = NSURL(string: "\(self.endpoint)?\(query)")!
        print(url)
        
        
        
        response(FPRequestError.InternalError, nil)
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

public class FPPublicPhotosRequest: FPRequest {
    public override init()
    {
        super.init()
        
        self.endpoint = "https://api.flickr.com/services/feeds/photos_public.gne"
    }
    
}
