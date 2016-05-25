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

let testStore:Source<Int, Int> = Source(state: 0)
testStore.actions["inc"] = ({ (state:Int?, _) -> Int in
    guard let s = state else {return 0}
    return s + 1
})
testStore.actions["dec"] = ({ (state:Int?, _) -> Int in
    guard let s = state else {return 0}
    return s - 1
})

// listener example, check console !
testStore.addListener { (v:Int?) in
    print("Transaction occured : \(v)")
}

testStore.transact()
testStore.transact("inc")