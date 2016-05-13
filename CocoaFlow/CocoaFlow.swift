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

/// allow object to register listener closure to be called upond change on a source
public class FlowListener<T>:FlowItem {
    let update:(T) -> Void
    init (name:String, updateFunction:(T) -> Void) {
        self.update = updateFunction
        super.init(name: name)
    }
}

/// Register a source (store) for the dispatcher
public class FlowSource<T>:FlowItem {
    
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
    var listeners: Dictionary<String, [FlowItem]> = Dictionary()
    
    func subscribe(listener:FlowItem) {
        listeners[listener.name]?.append(listener)
    }
    
    /// Unsubscribe a listener.
    func unsubscribe(listener:FlowItem) {
        if let listenerList = listeners[listener.name] {
            listeners[listener.name] = listenerList.filter {$0 !== listener}
        }
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
}