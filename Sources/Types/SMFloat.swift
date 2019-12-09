//
//  SMFloat.swift
//  SwiftMetal
//
//  Created by Hexagons on 2019-12-08.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import Foundation
import Combine

extension Float: SMRawType {}

public class SMFloat: SMValue<Float>, ExpressibleByFloatLiteral {
    
    static let kType: String = "float"
    public typealias T = Float
    
    override var values: [Float] { [value ?? -1] }
    
    init(entity: SMEntity, at index: Int) {
        super.init(type: SMFloat.kType)
        subscriptEntity = entity
        snippet = { "\(entity.snippet())[\(index)]" }
    }

    public init(_ value: T) {
        super.init(value, type: SMFloat.kType)
        snippet = { self.value != nil ? String(describing: self.value!) : "#" }
    }

    public init(_ futureValue: @escaping () -> (T)) {
        super.init(futureValue, type: SMFloat.kType)
    }

    required public convenience init(floatLiteral value: T) {
        self.init(value)
    }
    
    init(operation: SMOperation, snippet: @escaping () -> (String)) {
        super.init(operation: operation, snippet: snippet, type: SMFloat.kType)
    }
    
    public static func + (lhs: SMFloat, rhs: SMFloat) -> SMFloat {
        SMFloat(operation: SMOperation(lhs: lhs, rhs: rhs), snippet: { "(\(lhs.snippet()) + \(rhs.snippet()))" })
    }
    public static func - (lhs: SMFloat, rhs: SMFloat) -> SMFloat {
        SMFloat(operation: SMOperation(lhs: lhs, rhs: rhs), snippet: { "(\(lhs.snippet()) - \(rhs.snippet()))" })
    }
    public static func * (lhs: SMFloat, rhs: SMFloat) -> SMFloat {
        SMFloat(operation: SMOperation(lhs: lhs, rhs: rhs), snippet: { "(\(lhs.snippet()) * \(rhs.snippet()))" })
    }
    public static func / (lhs: SMFloat, rhs: SMFloat) -> SMFloat {
        SMFloat(operation: SMOperation(lhs: lhs, rhs: rhs), snippet: { "(\(lhs.snippet()) / \(rhs.snippet()))" })
    }

}

public class SMPublishedFloat: SMFloat {
    var valueSink: AnyCancellable!
    public init(_ publisher: Published<Float>.Publisher) {
        var value: Float!
        super.init { value }
        valueSink = publisher.sink { newValue in
            value = newValue
            self.sink?()
        }
        hasSink = true
    }
    deinit {
        valueSink.cancel()
    }
    required public convenience init(floatLiteral value: T) {
        fatalError("init(floatLiteral:) has not been implemented")
    }
}


//public struct SMRawFloat2 {
//    typealias T = Float
//    let tuple: SMTuple2<T>
//    init(_ value0: T, _ value1: T) {
//        tuple = SMTuple2<T>(SMFloat(value0), SMFloat(value1))
//    }
//}

public class SMFloat2: SMValue<SMTuple2<Float>>, ExpressibleByFloatLiteral {
    
    static let kType: String = "float2"
    public typealias T = Float
    
    public var x: SMFloat { self[0] }
    public var y: SMFloat { self[1] }
    
    public var r: SMFloat { self[0] }
    public var g: SMFloat { self[1] }
    
    public subscript(index: Int) -> SMFloat {
        guard (0..<2).contains(index) else {
            fatalError("subscript out of bounds for \(SMFloat2.kType)")
        }
        return SMFloat(entity: self, at: index)
    }
    
    override var values: [Float] { [value?.value0.value ?? -1, value?.value1.value ?? -1] }
    
    public convenience init(_ value0: SMFloat, _ value1: SMFloat) {
        self.init(SMTuple2<T>(value0, value1))
    }
    
//    public convenience init(_ futureValue: @escaping () -> (SMRawFloat2)) {
//        self.init({ futureValue().tuple })
//    }
    
    required public convenience init(floatLiteral value: T) {
        self.init(SMTuple2<T>(SMFloat(value),
                              SMFloat(value)))
    }
    
    init(_ value: SMTuple2<T>) {
        super.init(value, type: SMFloat2.kType, fromEntities: [
            value.value0, value.value1
        ])
        snippet = { "\(SMFloat2.kType)(\(self.value?.value0.snippet() ?? "#"), \(self.value?.value1.snippet() ?? "#"))" }
    }
    
    init(_ futureValue: @escaping () -> (SMTuple2<T>)) {
        super.init(futureValue, type: SMFloat2.kType)
    }
    
    init(operation: SMOperation, snippet: @escaping () -> (String)) {
        super.init(operation: operation, snippet: snippet, type: SMFloat2.kType)
    }
    
    init(fromEntities: [SMEntity] = []) {
        super.init(type: SMFloat2.kType, fromEntities: fromEntities)
    }
    
    public static func + (lhs: SMFloat2, rhs: SMFloat2) -> SMFloat2 {
        SMFloat2(operation: SMOperation(lhs: lhs, rhs: rhs), snippet: { "(\(lhs.snippet()) + \(rhs.snippet()))" })
    }
    public static func - (lhs: SMFloat2, rhs: SMFloat2) -> SMFloat2 {
        SMFloat2(operation: SMOperation(lhs: lhs, rhs: rhs), snippet: { "(\(lhs.snippet()) - \(rhs.snippet()))" })
    }
    public static func * (lhs: SMFloat2, rhs: SMFloat2) -> SMFloat2 {
        SMFloat2(operation: SMOperation(lhs: lhs, rhs: rhs), snippet: { "(\(lhs.snippet()) * \(rhs.snippet()))" })
    }
    public static func / (lhs: SMFloat2, rhs: SMFloat2) -> SMFloat2 {
        SMFloat2(operation: SMOperation(lhs: lhs, rhs: rhs), snippet: { "(\(lhs.snippet()) / \(rhs.snippet()))" })
    }
        
}


//public struct SMRawFloat4 {
//    typealias T = Float
//    let tuple: SMTuple4<T>
//    init(_ value0: T, _ value1: T, _ value2: T, _ value3: T) {
//        tuple = SMTuple4<T>(SMFloat(value0), SMFloat(value1), SMFloat(value2), SMFloat(value3))
//    }
//}

public class SMFloat4: SMValue<SMTuple4<Float>>, ExpressibleByFloatLiteral {
    
    static let kType: String = "float4"
    public typealias T = Float
    public typealias V = SMTuple4<Float>
    
    public var x: SMFloat { self[0] }
    public var y: SMFloat { self[1] }
    public var z: SMFloat { self[2] }
    public var w: SMFloat { self[3] }

    public var r: SMFloat { self[0] }
    public var g: SMFloat { self[1] }
    public var b: SMFloat { self[2] }
    public var a: SMFloat { self[3] }

    public subscript(index: Int) -> SMFloat {
        guard (0..<4).contains(index) else {
            fatalError("subscript out of bounds for \(SMFloat2.kType)")
        }
        return SMFloat(entity: self, at: index)
    }
    
    override var values: [Float] { [value?.value0.value ?? -1, value?.value1.value ?? -1, value?.value2.value ?? -1, value?.value3.value ?? -1] }
    
    public convenience init(_ value0: SMFloat, _ value1: SMFloat, _ value2: SMFloat, _ value3: SMFloat) {
        self.init(SMTuple4<T>(value0, value1, value2, value3))
    }
    
//    public convenience init(_ futureValue: @escaping () -> (SMRawFloat4)) {
//        self.init({ futureValue().tuple })
//    }
    
    required public convenience init(floatLiteral value: T) {
        self.init(SMTuple4<T>(SMFloat(value),
                              SMFloat(value),
                              SMFloat(value),
                              SMFloat(value)))
    }
    
    init(_ value: SMTuple4<T>) {
        super.init(value, type: SMFloat4.kType, fromEntities: [
            value.value0, value.value1, value.value2, value.value3
        ])
        snippet = { "\(SMFloat4.kType)(\(self.value?.value0.snippet() ?? "#"), \(self.value?.value1.snippet() ?? "#"), \(self.value?.value2.snippet() ?? "#"), \(self.value?.value3.snippet() ?? "#"))" }
    }
    
    init(_ futureValue: @escaping () -> (SMTuple4<T>)) {
        super.init(futureValue, type: SMFloat4.kType)
    }
    
    init(operation: SMOperation, snippet: @escaping () -> (String)) {
        super.init(operation: operation, snippet: snippet, type: SMFloat4.kType)
    }
    
    init(fromEntities: [SMEntity] = []) {
        super.init(type: SMFloat4.kType, fromEntities: fromEntities)
    }
    
    public static func + (lhs: SMFloat4, rhs: SMFloat4) -> SMFloat4 {
        SMFloat4(operation: SMOperation(lhs: lhs, rhs: rhs), snippet: { "(\(lhs.snippet()) + \(rhs.snippet()))" })
    }
    public static func - (lhs: SMFloat4, rhs: SMFloat4) -> SMFloat4 {
        SMFloat4(operation: SMOperation(lhs: lhs, rhs: rhs), snippet: { "(\(lhs.snippet()) - \(rhs.snippet()))" })
    }
    public static func * (lhs: SMFloat4, rhs: SMFloat4) -> SMFloat4 {
        SMFloat4(operation: SMOperation(lhs: lhs, rhs: rhs), snippet: { "(\(lhs.snippet()) * \(rhs.snippet()))" })
    }
    public static func / (lhs: SMFloat4, rhs: SMFloat4) -> SMFloat4 {
        SMFloat4(operation: SMOperation(lhs: lhs, rhs: rhs), snippet: { "(\(lhs.snippet()) / \(rhs.snippet()))" })
    }
    
    public static func += (lhs: inout SMFloat4, rhs: SMFloat4) {
        lhs = lhs + rhs
    }
        
}


public func float(_ value: Float) -> SMFloat {
    SMFloat(value)
}

public func float2(_ value0: SMFloat, _ value1: SMFloat) -> SMFloat2 {
    SMFloat2(value0, value1)
}

public func float4(_ value0: SMFloat, _ value1: SMFloat, _ value2: SMFloat, _ value3: SMFloat) -> SMFloat4 {
    SMFloat4(value0, value1, value2, value3)
}

public func min(_ values: SMFloat4...) -> SMFloat4 {
    let float = SMFloat4(fromEntities: values)
    float.snippet = {
        var snippet: String = ""
        snippet += "min("
        for (i, value) in values.enumerated() {
            if i > 0 {
                snippet += ", "
            }
            snippet += value.snippet()
        }
        snippet += ")"
        return snippet
    }
    return float
}

public func max(_ values: SMFloat4...) -> SMFloat4 {
    let float = SMFloat4(fromEntities: values)
    float.snippet = {
        var snippet: String = ""
        snippet += "max("
        for (i, value) in values.enumerated() {
            if i > 0 {
                snippet += ", "
            }
            snippet += value.snippet()
        }
        snippet += ")"
        return snippet
    }
    return float
}
