//
//  LinkedList.swift
//  CocoaFlow
//
//  Created by Sébastien Orban on 27/05/16.
//  Copyright © 2016 Random Mechanicals. All rights reserved.
//

import Foundation

class LinkedListItem<itemType> {
    let value:itemType
    var rest:LinkedListItem<itemType>?
    init(value:itemType, rest:LinkedListItem<itemType>? = nil) {
        self.rest = rest
        self.value = value
    }
}

class LinkedList<T> {
    var first:LinkedListItem<T>? = nil
    internal var l:LinkedListItem<T>?
    var last :LinkedListItem<T>? {
        get { return self.l }
    }

    init(item:LinkedListItem<T>) {
        self.first = item
        self.l = item
    }
    
    func appendFirst(item:LinkedListItem<T>) {
        item.rest = first
        first = item
    }
    
    /// - complexity: O(1)
    func appendLast(item:LinkedListItem<T>) {
        if (self.last != nil) {
            self.last!.rest = item
        }
        self.l = item
    }
    
    func dropFirst() {
        guard var f = first else {return}
        if let rest = f.rest {
            f = rest
        }
    }
    
    func dropLast() {
        guard let _ = last else {return}
    }
}