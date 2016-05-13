//: Test and example of the app

import UIKit
@testable import CocoaFlow

/**
 Change or add a value in a non mutable dictionary
 */
func updateDictionary<K, T>(dict:Dictionary<K, T>, key:K, value:T) -> Dictionary<K, T> {
    var tmpDict = dict
    tmpDict[key] = value
    return tmpDict
}


// So, how to use a generic function a get back a value hidden in a container object ?
let sources:[String:FlowItem] = ["test":FlowSource.init(name: "test", value: 3)]

// with a function with the same generic parameter, you could assess the return Type based on the parameter passed on.
func read<T>(name:String) -> T?{
    if let object = sources[name] {
        let source = object as! FlowSource<T>
        return source.read()
    }
    return nil
}

// solution is to assert the type in the receiver and be done with it. You still would have to know it beforehand to use it so... doesn't change a thing.
let r:Int? = read("test")

