//
//  FPActivityRequest.swift
//  FPCore
//
//  Created by Simon Jensen on 30/03/2017.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation


public class FPActivityRequest: FPRequest {
    
    
    
    
    public override func requestResponse(jsonObject: [String : Any]) throws -> (Any?) {
        if let data = jsonObject["items"] as? [String: Any]
            , let items = data["item"] as? [[String: Any]] {
            
            var itemList = [FPUserActivity]()
            for item in items {
                
                if let a = FPUserActivity(json: item) {
                    itemList.append(a)
                }
            }
            return itemList as Any?
        }
        
        return nil
    }
}
