//: Playground - noun: a place where people can play

import UIKit
@testable import CocoaFlow

var str = "Hello, playground"

var test = FlowDispatcher()

/// Listener object
public class FlowL<T> {
    var value:T
    init(value:T) {
        self.value = value
    }
    func read() -> T {
        return value;
    }
}

