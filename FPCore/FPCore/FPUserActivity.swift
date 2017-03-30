//
//  FPUserActivity.swift
//  FPCore
//
//  Created by Simon Jensen on 30/03/2017.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation

public enum FPUserActivityType: String {
    case photoset
    case photo
}

public class FPUserActivity: FPModel {
    public var id: Int?
    public var type: FPUserActivityType?
    public var title: String?
    public var activities: [FPActivity]?
    
    public required init?(json: [String : Any]) {
        
        if let type = json["type"] as? String {
            self.type = FPUserActivityType.init(rawValue: type)
            
        }
        
        if let activity = json["activity"] as? [[String:Any]] {
            var aa = [FPActivity]()
            for ac in activity {
                if let a = FPActivity(json: ac) {
                    aa.append(a)
                }
            }
        }
        
        
        self.id = json["id"] as? Int
        
        if let title = json["title"] as? [String: String] {
            self.title = title["_content"]
        }
        
    }
    
}
