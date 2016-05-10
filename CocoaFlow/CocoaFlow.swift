//
//  Flow.swift
//  Flow
//
//  Created by Sebastien Orban on 08/04/16.
//  Copyright © 2016 Random Mechanicals. All rights reserved.
//

// TODO: add check for recursive mutate/update loop
import Foundation

/// Let the object listener to change of a source in a Flow store
public protocol FlowListener {
    func update(values:Dictionary<String, AnyObject>)
}

public class FlowItem {
    var name:String
    init(name:String) {
        self.name = name
    }
}

/// Let the object work with the Flow system.
public class FlowSource<T>:FlowItem {
    /// list of possible mutation action.
    var actions:Dictionary<String, (T) -> T > = Dictionary()
    
    /// the actual value
    var val:T
    
    init(name:String, value:T) {
        self.val = value
        super.init(name: name)
    }
    
    /**
     Interface to read and eventually compute a value
     
     - returns: requested optional value
     */
    func read() -> T? {
        return val
    }
    
    /**
     Interface to mutate the value
     The FlowActions enum is used as the type of action the write value can execute, by default only the Update case exist. Of course an extension of this protocol can (and should be) used to extend the possibilities.
     
     - parameter value: the new value
     - parameter action: a FlowActions type enum.
     */
    func mutate(value:T, action:String) {
        
    }
}

/// Create a Flow store
public class FlowDispatcher {
    var sources: Dictionary<String, FlowItem> = Dictionary()
    var listeners: Dictionary<String, [FlowListener]> = Dictionary()
    
    
    /**
     You can subscribe to the updates manually.
     
     - parameter destination: Object to update.
     - parameter key: key to attach to.
     
     */
    func subscribe(key:String, listener:FlowListener) {
        listeners[key]?.append(listener)
    }
    
    
    func unsubscribe(key:String, listener:FlowListener) {
        
    }
    
    /**
     Register a data source in the store
     
     - parameter source: original source object
     - parameter key: identifier
     */
    func register(source:FlowItem) {
        sources[source.name] = source;
    }
}