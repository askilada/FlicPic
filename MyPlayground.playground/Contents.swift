//: Playground - noun: a place where people can play

import UIKit

protocol ReflectionP {
    
}

extension ReflectionP {
    subscript(key: String) -> Any? {
        get{
            let m = Mirror(reflecting: self)
            for child in m.children {
                if child.label == key {return child.value}
            }
            return nil
        }
        set {
            
        }
    }
}

class Demo {
    let fName = "John"
    let lName = "Doe"
    
    
}

extension Demo: ReflectionP {}

let d = Demo()

let m = Mirror(reflecting: d)
for ch in m.children {
    print("\(ch.label!) : \(ch.value)")
}