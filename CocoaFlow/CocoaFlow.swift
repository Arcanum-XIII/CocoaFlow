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
class Source<T:Equatable, P>:Item {
    var state:T?
    var previousState:[T?] = []
    var actions:[String:(T?, [P]) -> T] = [:]
    internal var listeners:[NSUUID:(T?) -> Void] = [:]
    let keepState:Int
    
    init(state:T, keepState:Int = 0) {
        self.state = state
        self.keepState = keepState
        self.previousState.append(state)
    }
    
    func addListener(action:(T?) -> Void) -> () -> Void {
        let uuid = NSUUID()
        listeners[uuid] = action
        return {
            self.listeners.removeValueForKey(uuid)
            return // needed because by default switch will return the value of the last statement
        }
        
    }
    
    /// Pure function that will apply action on the state.
    internal func applyAction(name:String, state:T?, param:[P]) -> T? {
        guard let a = actions[name]  else { return state }
        return a(state, param)
    }
    
    /// Handle the magic behind the state keeping maintenance
    internal func pushState(value:T?) -> Bool {
        guard keepState == 0 || previousState.last! == value else {return false}
        if(previousState.count > keepState) {
            previousState.removeFirst()
        }
        previousState.append(value)
        state = value
        return true
    }
    
    func transact(name:String = "", param:P...) -> T? {
        let result = applyAction(name, state: self.state, param: param)
        if (pushState(result)) {
            for (_ ,listener) in listeners {
                listener(result)
            }
        }
        return result
    }
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