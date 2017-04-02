//
//  FCRequest.swift
//  FPCore
//
//  Created by Simon Jensen on 21/03/17.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation

public typealias FPResponseHandler = (Error?, Any?) -> Void

public enum FPRequestError: Error {
    case InternalError
    case WrongMiniToken
    case NotImplementet
}

protocol FPRequestable {
    func requestResponse(jsonObject:[String:Any]) throws -> (Any?)
}

public class FPRequest: FPRequestable {
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
            return self.params[key]! 
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
        let signed = FPCore.shared.sign.make(input: stringToSign)
        print(signed)
        finalQuery.append("api_sig=\(signed)")
        let query = finalQuery.joined(separator: "&")
        
        return query
    }
    
    func generateSign(params: Params) -> String {
        let sorted = params.sorted(by: {$0.0 < $1.0})
        
        
        var stringToSign = self.secret
        for (key, value) in sorted {
            stringToSign.append("\(key)\(value)")
        }
        print("Str to sign:")
        print(stringToSign)
        let sign = FPCore.shared.sign.make(input: stringToSign)
        
        return sign
    }
    
    public func exec(response: @escaping FPResponseHandler) {
        
        let params = makeParams()
        let query = paramsToString(params)
        
        let url = URL(string: "\(self.endpoint)?\(query)")!
        print(url)
        
        let request = URLRequest(url: url)
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, urlresponse, err) in
            if err != nil {
                return response(err, nil)
            }
            
            
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                let responseObj = try self.requestResponse(jsonObject: jsonObject)
                return response(nil, responseObj)
            }
            catch
            {
                return response(error, nil)
            }   
        }
        task.resume()
    }
    
    func requestResponse(jsonObject: [String : Any]) throws -> (Any?) {
        throw FPRequestError.NotImplementet
    }
    
    
}



