//
//  Flow.swift
//  Flow
//
//  Created by Sebastien Orban on 08/04/16.
//  Copyright © 2016 Random Mechanicals. All rights reserved.
//

// TODO: add check for recursive mutate/update loop
import Foundation

/// Basic actions enum - to be extended.
public enum FlowActions {
    case Update;
}

/// Let the object listener to change of a source in a Flow store
public protocol FlowListener {
    func update(values:Dictionary<String, AnyObject>)
}

/// Let the object work with the Flow system.
public protocol FlowSource {
    
    /// list of possible mutation action. Need to be extended
    var actions:Dictionary<String, AnyObject> {get set}
    
    /**
     Interface to read and eventually compute a value
     
     - returns: requested optional value
     */
    func read() -> AnyObject?
    
    /**
     Interface to mutate the value
     The FlowActions enum is used as the type of action the write value can execute, by default only the Update case exist. Of course an extension of this protocol can (and should be) used to extend the possibilities.
     
     - parameter value: the new value
     - parameter action: a FlowActions type enum.
     */
    func mutate(value:AnyObject, action:String)
}


/// Listener object
public class FlowL {
    func listenerForString(str:String) {
        
    }
}

/// Create a Flow store
public class FlowDispatcher {
    var sources: Dictionary<String, FlowSource> = Dictionary()
    var listeners: Dictionary<String, [FlowListener]> = Dictionary()
    /**
     Try to get all value from the list of key given
     
     - parameter keys: list of key you want go get from the store
     
     - returns: a list of keys with possible result
     */
    func read(keys:[String]) -> Dictionary<String, AnyObject?> {
        var results:Dictionary<String, AnyObject> = Dictionary()
        for key in keys {
                results[key] = read(key)
        }
        return results
    }
    
    /**
     Try to get the value for a key
     
     - parameter key: **key** you hope to get
     
     - returns: the possible result
     */
    func read(key: String) -> AnyObject? {
        if let source = sources[key] {
            return source.read()
        }
        return nil
    }
    
    /**
     Will update the key with the new value using the register action and then trigger the update method of all subscriber.
     
     - parameter key: key to be update
     - parameter value: the value the mutater should get
     */
    func transact(key:String, value:AnyObject) {
        let source:FlowSource = sources[key]!
        let listenerList:[FlowListener] = listeners[key]!
        source.mutate(value, action:"update")
        if let v = read(key) {
            for listener in listenerList {
                listener.update([key:v])
            }
        }
    }
    
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
    func register(source:FlowSource, key:String) {
        sources[key] = source;
    }
}