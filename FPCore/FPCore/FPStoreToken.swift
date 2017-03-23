//
//  FPStoreToken.swift
//  FPCore
//
//  Created by Simon Jensen on 23/03/17.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation


public protocol FPStoreToken {
    func load() throws -> String
    func save(token: String) throws

}
