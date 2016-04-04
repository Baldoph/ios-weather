//
//  Associated.swift
//  SampleWLSwiftNetworking
//
//  Created by Antoine Gamond on 22/02/2016.
//  Copyright © 2016 Worldline. All rights reserved.
//

import Foundation

public struct AssociatedObjectKey {
    public static var ViewModel = "ViewModelKey"
    public static var DisposeBag = "DisposeBagKey"
}

/// The Associated class can encapsulated all non-AnyObject types like Struct.
public final class Associated<T> {

    typealias AssociatedType = T
    let value: AssociatedType

    init(_ value: AssociatedType) {
        self.value = value
    }
}

/**
 Returns the optional value associated with a given object for a given key.

 - parameter base: The source object for the association.
 - parameter key:  The key for the association.

 - returns: The optional value associated with the key for object.
 */
public func associatedObject<T>(base: AnyObject, key: UnsafePointer<Void>) -> T? {

    if let associated = objc_getAssociatedObject(base, key) as? T {
        return associated
    } else if let v = objc_getAssociatedObject(base, key) as? Associated<T> {
        return v.value
    } else {
        return nil
    }
}

/**
 Returns the value associated with a given object for a given key.

 - parameter base: The source object for the association.
 - parameter key:  The key for the association.
 - parameter initialiser: The default initializer for T

 - returns: The value associated with the key for object.
 */
public func associatedObject<T>(base: AnyObject, key: UnsafePointer<Void>, initialiser: () -> T) -> T {

    if let associated = objc_getAssociatedObject(base, key) as? T {
        return associated
    } else if let v = objc_getAssociatedObject(base, key) as? Associated<T> {
        return v.value
    }

    let associated = initialiser()

    associateObject(base, key: key, value: associated)

    return associated
}

/**
 Sets an associated value for a given object using a given key.

 - parameter base:  The source object for the association.
 - parameter key:   The key for the association.
 - parameter value: The value to associate with the key key for object.
 */
public func associateObject<T>(base: AnyObject, key: UnsafePointer<Void>, value: T) {

    if let value = value as? AnyObject {
        objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
    } else {
        objc_setAssociatedObject(base, key, Associated(value), .OBJC_ASSOCIATION_RETAIN)
    }
}
