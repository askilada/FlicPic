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


public class FPCore {
    public static let shared: FPCore = FPCore();
    let apiKey = ""
    let apiSecret = ""
}
