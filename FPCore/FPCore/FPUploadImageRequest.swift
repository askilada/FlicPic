//
//  FPUploadImageRequest.swift
//  FPCore
//
//  Created by Simon Jensen on 02/04/17.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation



public class FPUploadImageRequest: FPRequest {
    
    public var photo: UIImage
    public var auth_token = FPCore.shared.token!.authToken
    var parser  = Parser()
    
    class Parser: NSObject, XMLParserDelegate {
        var response: [String: String] = [:]
        
        
        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            
            if elementName == "rsp" {
                if attributeDict["stat"] == "fail" {
                    response["status"] = "fail"
                } else if attributeDict["stat"] == "ok" {
                    response["status"] = "ok"
                }
            }
            
            if elementName == "err" {
                response["error"] = attributeDict["msg"]!
            }
        }
        
        func parserDidEndDocument(_ parser: XMLParser) {
            
        }
    }
    
    func makeRandStr() -> String {
        var returnStr = "--------------"
        let allowd = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        for _ in 1...10 {
            let randIndex = Int(arc4random_uniform(UInt32(allowd.characters.count)))
            let a = allowd.index(allowd.startIndex, offsetBy: randIndex)
            returnStr.append(allowd[a])
        }
        
        return returnStr
    }
    
    public init(image: UIImage) {
        self.photo = image
        
        super.init()
        
        self.addIgnore("photo")
        self.addIgnore("method")
        self.addIgnore("format")
        self.addIgnore("nojsoncallback")
        
        self.endpoint = "https://up.flickr.com/services/upload/"
        //self.endpoint = "https://requestb.in/1k987cg1"
    }
    
    func partBlock(key:String, value:String, bound: String) -> Data {
        var data = Data()
        data.append("--\(bound)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using:.utf8)!)
        data.append("\(value)\r\n".data(using: .utf8)!)
        
        return data
    }
    
    public override func exec(response: @escaping FPResponseHandler) {
        let bounds = makeRandStr()
        var multipartData = Data()
        let params = self.makeParams()
        let sign = self.generateSign(params: params)
        let imageData = UIImageJPEGRepresentation(self.photo, 0.3)
        
        var sorted = params.sorted(by: {$0.0 < $0.1})
        
        for (key, value) in sorted {
            let d = partBlock(key: key, value: value, bound: bounds)
            multipartData.append(d)
            
        }
        
        
        multipartData.append("--\(bounds)\r\n".data(using: .utf8)!)
        multipartData.append("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n".data(using:.utf8)!)
        multipartData.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        multipartData.append(imageData!)
        multipartData.append("\r\n".data(using: .utf8)!)
        
        
        let d = partBlock(key: "api_sig", value: sign, bound: bounds)
        multipartData.append(d)
        
        multipartData.append("--\(bounds)--\r\n".data(using: .utf8)!)
        
        let url = URL(string: self.endpoint)!
        var req = URLRequest(url: url)
        req.cachePolicy = .reloadIgnoringLocalCacheData
        req.httpMethod = "POST"
        req.httpBody = multipartData
        req.setValue("multipart/form-data; boundary=\(bounds)", forHTTPHeaderField: "Content-Type")
        //req.setValue("\(multipartData.count)", forHTTPHeaderField: "Content-Length")
        
        let task = URLSession.shared.dataTask(with: req) { (data, urlresponse, error) in
            let httpresponse = urlresponse as! HTTPURLResponse
            
            if error != nil {
                response(error, nil)
                return
            }
            
            let p = XMLParser(data: data!)
            p.delegate = self.parser
            if p.parse() {
                print("Parsed")
                
                if self.parser.response["status"]! == "fail" {
                    response(FPRequestError.InternalError, nil)
                    return
                }
            } else {
                print("not parsed")
                return
            }
            
            response(nil, nil)
            return
        }
        task.resume()
        
        return
        
        
    }
}

