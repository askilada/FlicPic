//
//  FPActivity.swift
//  FPCore
//
//  Created by Simon Jensen on 30/03/2017.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation


public enum FPActivityType: String {
    case comment
}

public class FPActivity: FPModel {
    
    public private(set) var type: FPActivityType?
    public private(set) var userId: String?
    public private(set) var userName: String?
    public private(set) var content: String?
    
    
    
    required public init?(json: [String : Any]) {
        
        if let type = json["type"] as? String {
            self.type = FPActivityType.init(rawValue: type)
        }
        self.userId = json["user"] as? String
        self.userName = json["username"] as? String
        self.content = json["_content"] as? String
        
        
    }
    
}
