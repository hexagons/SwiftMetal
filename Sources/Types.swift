//
//  Types.swift
//  SwiftMetal
//
//  Created by Hexagons on 2019-12-08.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import Foundation
#if os(macOS)
import Cocoa
#else
import UIKit
#endif

#if os(macOS)
public typealias _Image = NSImage
public typealias _Color = NSColor
#else
public typealias _Image = UIImage
public typealias _Color = UIColor
#endif

struct SMVariablePack {
    let entity: SMEntity
    let index: Int
    var name: String {
        return "v\(index)"
    }
    var code: String {
        "\(entity.type) \(name) = \(entity.snippet());"
    }
}

struct SMUniformPack {
    let entity: SMEntity
    let index: Int
    var name: String {
        return "u\(index)"
    }
    var code: String {
        "\(entity.type) \(name);"
    }
    var snippet: String {
        "us.\(name)"
    }
}

struct SMOperation {
    let lhs: SMEntity
    let rhs: SMEntity
}

public protocol SMRaw {}
public protocol SMRawType: SMRaw {}

public class SMTuple<RT: SMRawType>: SMRaw {}

public class SMTuple2<RT: SMRawType>: SMTuple<RT> {
    let value0: SMValue<RT>
    let value1: SMValue<RT>
    init(_ value0: SMValue<RT>,
         _ value1: SMValue<RT>) {
        self.value0 = value0
        self.value1 = value1
    }
}

public class SMTuple3<RT: SMRawType>: SMTuple<RT> {
    let value0: SMValue<RT>
    let value1: SMValue<RT>
    let value2: SMValue<RT>
    init(_ value0: SMValue<RT>,
         _ value1: SMValue<RT>,
         _ value2: SMValue<RT>) {
        self.value0 = value0
        self.value1 = value1
        self.value2 = value2
    }
}

public class SMTuple4<RT: SMRawType>: SMTuple<RT> {
    let value0: SMValue<RT>
    let value1: SMValue<RT>
    let value2: SMValue<RT>
    let value3: SMValue<RT>
    init(_ value0: SMValue<RT>,
         _ value1: SMValue<RT>,
         _ value2: SMValue<RT>,
         _ value3: SMValue<RT>) {
        self.value0 = value0
        self.value1 = value1
        self.value2 = value2
        self.value3 = value3
    }
}

struct Line {
    let indent: Int
    let snippet: String
    init(in indent: Int = 0, _ snippet: String = "") {
        self.indent = indent
        self.snippet = snippet
    }
    static func merge(_ lines: [Line]) -> String {
        lines.map({ line -> String in
            var row = ""
            for _ in 0..<line.indent {
                row += "    "
            }
            row += line.snippet;
            return row
        }).joined(separator: "\n") + "\n"
    }
}

public class SMUV: SMFloat2 {
    public init() {
        super.init()
        snippet = { "uv" }
    }
    required public convenience init(floatLiteral value: T) {
        fatalError("init(floatLiteral:) has not been implemented")
    }
    required public convenience init(integerLiteral value: Int) {
        fatalError("init(integerLiteral:) has not been implemented")
    }
}
