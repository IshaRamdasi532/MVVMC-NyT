//
//  Observer.swift
//  NyTimes
//
//  Created by APPLE on 01/05/20.
//  Copyright © 2020 Isha Ramdasi. All rights reserved.
//

import Foundation

public class ObserverSetEntry<Parameters> {
    fileprivate weak var object: AnyObject?
    fileprivate let f: (AnyObject) -> (Parameters) -> Void
    
    fileprivate init(object: AnyObject, f: @escaping (AnyObject) -> (Parameters) -> Void) {
        self.object = object
        self.f = f
    }
}

public class ObserverSet<Parameters>: CustomStringConvertible {
    // Locking support
    
    private var queue = DispatchQueue(label: "com.ny.nytimes", attributes: [])
    
    private func synchronized(_ f: () -> Void) {
        queue.sync(execute: f)
    }
    
    // Main implementation
    
    private var entries: [ObserverSetEntry<Parameters>] = []
    
    public init() {}
    
    @discardableResult
    public func add<T: AnyObject>(_ object: T, _ f: @escaping (T) -> (Parameters) -> Void) -> ObserverSetEntry<Parameters> {
        let entry = ObserverSetEntry<Parameters>(object: object, f: { f($0 as! T) })
        synchronized {
            self.entries.append(entry)
        }
        return entry
    }
    
    @discardableResult
    public func add(_ f: @escaping (Parameters) -> Void) -> ObserverSetEntry<Parameters> {
        return self.add(self, { ignored in f })
    }
    
    public func remove(_ entry: ObserverSetEntry<Parameters>) {
        synchronized {
            self.entries = self.entries.filter { $0 !== entry }
        }
    }
    
    public func remove(_ object: AnyObject) {
        synchronized {
            self.entries = self.entries.filter { $0.object !== object }
        }
    }
    
    public func notify(_ parameters: Parameters) {
        var toCall: [(Parameters) -> Void] = []
        
        synchronized {
            for entry in self.entries {
                if let object: AnyObject = entry.object {
                    toCall.append(entry.f(object))
                }
            }
            self.entries = self.entries.filter { $0.object != nil }
        }
        
        for f in toCall {
            f(parameters)
        }
    }
    
    // Printable
    
    public var description: String {
        var entries: [ObserverSetEntry<Parameters>] = []
        synchronized {
            entries = self.entries
        }
        
        let strings = entries.map {
            entry in
            (entry.object === self
                ? "\(String(describing: entry.f))"
                : "\(String(describing: entry.object)) \(String(describing: entry.f))")
        }
        let joined = strings.joined(separator: ", ")
        
        return "\(Mirror(reflecting: self).description): (\(joined))"
    }
}
