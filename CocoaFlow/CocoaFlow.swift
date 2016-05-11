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
    func update<T>(values:Dictionary<String, T>)
}

///
public class FlowItem {
    var name:String
    init(name:String) {
        self.name = name
    }
}

/// Register a source (store) for the dispatcher
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
     List the possible action for a source
     
     - returns: the possible list of action
    */
    func actionsList() -> [String] {
        return actions.map({
            (key:String, _) -> String in
                return key
        })
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
     */
    func mutate(value:T, action:String) {
        
    }
}

/// Create a dispatcher
public class FlowDispatcher {
    var sources: Dictionary<String, FlowItem> = Dictionary()
    var listeners: Dictionary<String, [FlowListener]> = Dictionary()
    
    func subscribe(key:String, listener:FlowListener) {
        listeners[key]?.append(listener)
    }
    
    /// Unsubscribe a listener.
    func unsubscribe(key:String, listener:FlowListener) {
    }
    
    /**
     Register a data source
     */
    func register(source:FlowItem) {
        sources[source.name] = source;
    }
    
    /**
     Remove a data source
    */
}