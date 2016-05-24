//
//  Flow.swift
//  Flow
//
//  Created by Sebastien Orban on 08/04/16.
//  Copyright © 2016 Random Mechanicals. All rights reserved.
//

// TODO: add check for recursive mutate/update loop
import Foundation

class Item {
    func removeListener(uuid:NSUUID) {}
}

/// Usable source (store) for the dispatcher
class Source<T>:Item {
    internal let actions:(String, T) -> T?
    internal let readMethod:() -> T
    var listeners:[NSUUID:(T) -> Void] = [:]
    
    // actions will be used in a closure that will handle the dispatching.
    init(actionsList:[String:(T) -> T], read:() -> T) {
        func evalAction(actionName:String, v:T) -> T? {
            if let action = actionsList[actionName] {
                return action(v)
            }
            return nil
        }
        self.actions = evalAction
        self.readMethod = read
        super.init()
    }
    
    // a transaction will notify listener that a new value is there
    func transact(name:String, value:T) -> T? {
        let result = actions(name, value)
        if let r = result {
            for (_ ,listener) in listeners {
                listener(r)
            }
        }
        return result
    }
    
    /**
     Will add a closure listener that will be triggered on transaction
     
     - parameter action: closure that will be triggered upon a change. Will receive the new value
     - returns: closure to remove the listener
     */
    func listen(action:(T) -> Void) -> () -> Void {
        let uuid = NSUUID()
        listeners[uuid] = action
        return {
            self.listeners.removeValueForKey(uuid)
            return // needed because by default switch will return the value of the last statement
        }
        
    }
    
    func read() -> T { return self.readMethod() }
}

/// Create a dispatcher
public class FlowDispatcher {
    var sources: Dictionary<String, Item> = Dictionary()
    
    func subscribe<T:Comparable>(sourceName:String, action:(T) -> Void) -> (() -> Void)? {
        if let object = sources[sourceName] {
            let source = object as! Source<T>
            return source.listen(action)
        }
        return nil
    }
    
    /// Unsubscribe a listener.
    func unsubscribe(sourceName:String, uuid:NSUUID) {
        if let t = sources[sourceName] {
            t.removeListener(uuid)
        }
    }
    
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
    
    // helper function for sources
    func read<T>(name:String) -> T?{
        if let object = sources[name] {
            let source = object as! Source<T>
            return source.read()
        }
        return nil
    }
    
    func transact<T>(name:String, value:T) -> T? {
        if let object = sources[name] {
            let source = object as! Source<T>
            return source.transact(name, value: value)
        }
        return nil
    }
}