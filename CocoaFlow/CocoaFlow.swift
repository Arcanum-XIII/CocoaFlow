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

/// Register a source (store) for the dispatcher
public class FlowSource<T>:FlowItem {
    /// listener closure with their uuid
    var listener:Dictionary<String, (T) -> Void> = Dictionary()
    
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
    func addListener(action:(T) -> Void) -> String {
        let uuid = NSUUID().UUIDString
        listener[uuid] = action
        return uuid
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
    func mutate(value:T, action:String) -> T {
        if let method = actions[action] {
            self.value = method(value, self.value)
        }
        return value
    }
}

/// Create a dispatcher
public class FlowDispatcher {
    var sources: Dictionary<String, FlowItem> = Dictionary()
    
    func subscribe<T>(sourceName:String, action:(T) -> Void) -> String? {
        if let object = sources[sourceName] {
            let source = object as! FlowSource<T>
            return source.addListener(action)
        }
        return nil
    }
    
    /// Unsubscribe a listener.
    func unsubscribe<T>(sourceName:String, uuid:String) -> T? {
        if let object = sources[sourceName] {
            let source = object as! FlowSource<T>
            source.actions.removeValueForKey(uuid)
            return source.read()
        }
        return nil
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
    
    func read<T>(name:String) -> T?{
        if let object = sources[name] {
            let source = object as! FlowSource<T>
            return source.read()
        }
        return nil
    }
    
    /* Need to be pushed into the source
    func transact<T:Comparable>(source:String, withAction:String, forValue:T) -> T? {
        if let object = sources[source] {
            let store = object as! FlowSource<T>
            let oldValue = store.read()
            let result = store.mutate(forValue, action: withAction)
            if let old = oldValue {
                if (old != result) {
                    
                }
            }
            return result
        }
        return nil
    }*/
}