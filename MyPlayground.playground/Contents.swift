//: Test and example of the app

import UIKit
@testable import CocoaFlow

var test = FlowDispatcher()

/**
 Change or add a value in a non mutable dictionary
 */
func updateDictionary<K, T>(dict:Dictionary<K, T>, key:K, value:T) -> Dictionary<K, T> {
    var tmpDict = dict
    tmpDict[key] = value
    return tmpDict
}