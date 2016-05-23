//
//  Flow.swift
//  Flow
//
//  Created by Sebastien Orban on 08/04/16.
//  Copyright © 2016 Random Mechanicals. All rights reserved.
//

// TODO: add check for recursive mutate/update loop
import Foundation

/// Base class, so we can add it to any dict or array.
public class FlowItem {
    var name:String
    init(name:String) {
        self.name = name
    }
}

protocol FlowListener {
    func removeListener(uuid:NSUUID)
}

/// Register a source (store) for the dispatcher
public class FlowSource<T:Comparable>:FlowItem, FlowListener {
    /// listener closure with their uuid
    var listener:Dictionary<NSUUID, (T) -> Void> = Dictionary()
    
    /// container for the value
    var value:T
    
    /// list of possible mutation action.
    var actions:[String: (T, T) -> T] = Dictionary()
    
    init(name:String, value:T) {
        self.value = value
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
     Will add a closure listener that will be triggered on transaction
     
     - returns: UUID of the closure
    */
    func addListener(action:(T) -> Void) -> NSUUID {
        let uuid = NSUUID()
        listener[uuid] = action
        return uuid
    }
    
    /// remove a listener
    func removeListener(uuid:NSUUID) {
        listener.removeValueForKey(uuid)
    }
    
    /**
     Interface to read and eventually compute a value
     
     - returns: requested optional value
     */
    func read() -> T? {
        return value
    }
    
    /**
     Interface to mutate the value
     */
    func transact(action:String, forValue:T) -> T {
        let oldValue = value
        if let method = actions[action] {
            self.value = method(forValue, self.value)
            if(oldValue != value) {
                for (_, method) in listener {
                    method(self.value)
                }
            }
        }
        return self.value
    }
}

/// Create a dispatcher
public class FlowDispatcher {
    var sources: Dictionary<String, FlowItem> = Dictionary()
    
    func subscribe<T:Comparable>(sourceName:String, action:(T) -> Void) -> NSUUID? {
        if let object = sources[sourceName] {
            let source = object as! FlowSource<T>
            return source.addListener(action)
        }
        return nil
    }
    
    /// Unsubscribe a listener.
    func unsubscribe(sourceName:String, uuid:NSUUID) {
        let t = sources[sourceName] as! FlowListener
        t.removeListener(uuid)
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
    func unregister(name:String) {
        sources.removeValueForKey(name)
    }
    
    func read<T:Comparable>(name:String) -> T?{
        if let object = sources[name] {
            let source = object as! FlowSource<T>
            return source.read()
        }
        return nil
    }
}