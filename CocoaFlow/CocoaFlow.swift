//
//  Flow.swift
//  Flow
//
//  Created by Sebastien Orban on 08/04/16.
//  Copyright © 2016 Random Mechanicals. All rights reserved.
//

// TODO: add check for recursive mutate/update loop
import Foundation

// generic class can't be added directly to a dictionnary
class Item {
    
}

/// Source dispatching and management class
/// Think of this as the middle management : passing data around, and making 
/// sure that everyone is aware of change.
/// T is the resulting value you get out of the source, P is the parameter type
/// used to transact the source
class Source<T, P>:Item {
    internal let actions:(String, P) -> T?
    internal let readMethod:() -> T
    var listeners:[NSUUID:(T) -> Void] = [:]
    
    /// - parameter actionsList: dictionnary of action, action being defined as closure.
    /// - parameter read: closure to get the current value of the Source
    init(actionsList:[String:(P) -> T], read:() -> T) {
        func evalAction(actionName:String, v:P) -> T? {
            if let action = actionsList[actionName] {
                return action(v)
            }
            return nil
        }
        self.actions = evalAction
        self.readMethod = read
        super.init()
    }
    
    /// a transaction will notify listener that a new value is there
    func transact(name:String, value:P) -> T? {
        let result = actions(name, value)
        if let r = result {
            for (_ ,listener) in listeners {
                listener(r)
            }
        }
        return result
    }
    
     /// Will add a closure listener that will be triggered on transaction
     ///
     /// - parameter action: closure that will be triggered upon a change. Will receive the new value
     /// - returns: closure to remove the listener
    func addListener(action:(T) -> Void) -> () -> Void {
        let uuid = NSUUID()
        listeners[uuid] = action
        return {
            self.listeners.removeValueForKey(uuid)
            return // needed because by default switch will return the value of the last statement
        }
        
    }
    
    func read() -> T { return self.readMethod() }
}

/// Create a basic dispatcher
public class Dispatcher {
    var sources: Dictionary<String, Item> = Dictionary()
    
    /**
     Register a data source
     */
    func register(name:String, source:Item) {
        sources[name] = source;
    }
    
    /**
     Remove a data source
    */
    func unregister(name:String) {
        sources.removeValueForKey(name)
    }
}