//
//  SMShader.swift
//  SwiftMetal
//
//  Created by Anton Heestand on 2019-12-06.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import Foundation
import Metal

public class SMShader: Identifiable, Equatable {
    
    public let id = UUID()
        
    enum FuncError: Error {
        case shader
        case someUniformsAreNil
    }
            
    let textures: [SMTexture]
    
    let baseEntity: SMEntity
    
    var sinks: [() -> ()] = []
    
    let smCode: SMCode
    public var code: String!
    
    var render: (() -> ())?
    
    public init(_ entityCallback: (SMUV) -> (SMFloat4)) {
        baseEntity = entityCallback(SMUV())
        textures = SMBuilder.textures(for: baseEntity)
        smCode = SMBuilder.build(for: baseEntity)
        SMBuilder.connectSinks(for: baseEntity) {
//            print("SwiftMetal - Shader - Update")
            self.render?()
        }
        code = makeCode()
        print("SwiftMetal - Shader >>> >>> >>>", id.uuidString)
        print(code!)
        print("SwiftMetal - Shader <<< <<< <<<", id.uuidString)
    }
    
    fileprivate func makeCode() -> String {
        
        let code = smCode
        
        var lines: [Line] = []
        
        lines.append(Line("//"))
        lines.append(Line("//  SwiftMetal"))
        lines.append(Line("//  Auto generated metal code"))
        lines.append(Line("//"))
        lines.append(Line())
        
        lines.append(Line("#include <metal_stdlib>"))
        lines.append(Line("using namespace metal;"))
        lines.append(Line())
        
        if !code.functions.isEmpty {
            for function in code.functions {
                lines.append(Line(function.code))
            }
        }
        
        if !code.uniforms.isEmpty {
            lines.append(Line("struct Uniforms {"))
            for uniform in code.uniforms {
                lines.append(Line(in: 1, uniform.code))
            }
            lines.append(Line("};"))
            lines.append(Line())
        }
        
        lines.append(Line("kernel void swiftMetal("))
        if !code.uniforms.isEmpty {
            lines.append(Line(in: 2, "constant Uniforms& us [[ buffer(0) ]],"))
        }
        lines.append(Line(in: 2, "texture2d<float, access::write> tex [[ texture(0) ]],"))
        for (i, texture) in textures.enumerated() {
//            lines.append(Line(in: 2, "texture2d<float, access::read> \(texture.name) [[ texture(\(i + 1)) ]],"))
            lines.append(Line(in: 2, "texture2d<float, access::sample> \(texture.name) [[ texture(\(i + 1)) ]],"))
        }
        lines.append(Line(in: 2, "uint2 pos [[ thread_position_in_grid ]],"))
        lines.append(Line(in: 2, "sampler smp [[ sampler(0) ]]"))
        lines.append(Line(in: 0, ") {"))
        lines.append(Line(in: 1))

        lines.append(Line(in: 1, "int x = pos.x;"))
        lines.append(Line(in: 1, "int y = pos.y;"))
        lines.append(Line(in: 1, "int w = tex.get_width();"))
        lines.append(Line(in: 1, "int h = tex.get_height();"))
        lines.append(Line(in: 1))
        
        lines.append(Line(in: 1, "if (x >= w || y >= h) { return; }"))
        lines.append(Line(in: 1))
        
        lines.append(Line(in: 1, "float u = (float(x) + 0.5) / float(w);"))
        lines.append(Line(in: 1, "float v = (float(y) + 0.5) / float(h);"))
        lines.append(Line(in: 1, "float2 uv = float2(u, v);"))
        lines.append(Line(in: 1))
        
        if !textures.isEmpty {
            for texture in textures {
//                lines.append(Line(in: 1, "float4 \(texture.snippet()) = \(texture.name).read(pos);"))
                lines.append(Line(in: 1, "float4 \(texture.snippet()) = \(texture.name).sample(smp, uv);"))
            }
            lines.append(Line(in: 1))
        }
        
        if !code.variables.isEmpty {
            code.variables.forEach { variable in
                lines.append(Line(in: 1, variable.code))
            }
            lines.append(Line(in: 1))
        }
        
        lines.append(Line(in: 1, "\(baseEntity.type) out = \(code.snippet);"))
        lines.append(Line(in: 1))
        
        lines.append(Line(in: 1, "tex.write(out, pos);"))
        lines.append(Line(in: 1))
        
        lines.append(Line("}"))
        
        return Line.merge(lines)
    }
    
    public func make(with metalDevice: MTLDevice) throws -> MTLFunction {
        let lib: MTLLibrary = try metalDevice.makeLibrary(source: code, options: nil)
        guard let shader: MTLFunction = lib.makeFunction(name: "swiftMetal") else {
            throw FuncError.shader
        }
        return shader
    }
    
    func rawUniforms() throws -> [SMRawType] {
        var rawUniforms: [SMRawType] = []
        for uniform in smCode.uniforms {
            guard let rawSubUniforms = uniform.entity.rawUniforms else {
                throw FuncError.someUniformsAreNil
            }
            for subUniform in rawSubUniforms {
                rawUniforms.append(subUniform)
            }
        }
        return rawUniforms
    }
    
    public static func == (lhs: SMShader, rhs: SMShader) -> Bool {
        lhs.id == rhs.id
    }
    
}
