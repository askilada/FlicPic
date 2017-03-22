//
//  FPCore+Dic.swift
//  FPCore
//
//  Created by Simon Jensen on 22/03/2017.
//  Copyright © 2017 Askilada. All rights reserved.
//

import Foundation

extension Dictionary {
    func mergeWith(dic: [Key: Value]) -> [Key:Value] {
        var mergedDir: [Key:Value] = [:]
        [self, dic].forEach { (newD) in
            for (k,v) in newD
            {
                mergedDir[k] = v
            }
        }
        return mergedDir
    }
}
