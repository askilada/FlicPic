//
//  MD5Sign.swift
//  FlicPic
//
//  Created by Simon Jensen on 22/03/17.
//  Copyright © 2017 Simon Jensen. All rights reserved.
//

import Foundation
import FPCore

class MD5Sign: FPMD5Hash {
    func make(input: String) -> String {
        
        let cstr = input.cString(using: .utf8)
        let cstrLen = CC_LONG(input.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(cstr!, cstrLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate(capacity: digestLen)
        
        return String(format: hash as String)
    }
}
