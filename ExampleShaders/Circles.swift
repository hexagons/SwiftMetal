//
//  Circles.swift
//  SwiftMetal_iOS
//
//  Created by Hexagons on 2019-12-13.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import SwiftUI
import SwiftMetal

struct CirclesView: View {
    @State var locationX: Float = 0.0
    @State var locationY: Float = 0.0
    var body: some View {
        ZStack {
            Color.black
            SMView {
                SMShader { uv, aspect in
                    
                    let xy: SMFloat2 = float2((uv.x - 0.5) * aspect, uv.y - 0.5)
                    
//                    let cone: SMFunc<SMFloat> = function { args -> SMFloat in
//                        let xy: SMFloat2 = args[0] as! SMFloat2
//                        return sqrt(pow(xy.x, 2) + pow(xy.y, 2))
//                    }
                    
                    let circleCenter: SMFunc<SMFloat2> = function { args -> SMFloat2 in
                        let a: SMFloat2 = args[0] as! SMFloat2
                        let b: SMFloat2 = args[1] as! SMFloat2
                        let c: SMFloat2 = args[2] as! SMFloat2
                        
                        let yDelta_a: SMFloat = b.y - a.y;
                        let xDelta_a: SMFloat = b.x - a.x;
                        let yDelta_b: SMFloat = c.y - b.y;
                        let xDelta_b: SMFloat = c.x - b.x;
                        
                        let aSlope: SMFloat = yDelta_a / xDelta_a;
                        let bSlope: SMFloat = yDelta_b / xDelta_b;
                        
                        let v0: SMFloat = aSlope * bSlope * (a.y - c.y)
                        let v1: SMFloat = bSlope * (a.x + b.x)
                        let v2: SMFloat = aSlope * (b.x + c.x)
                        let x: SMFloat = (v0 + v1 - v2) / (2 * (bSlope - aSlope))
                        
                        let v3: SMFloat = x - (a.x + b.x) / 2
                        let v4: SMFloat = (a.y + b.y) / 2
                        let y: SMFloat = -1 * v3 / aSlope + v4
                        
                        return float2(x, y)
                    }
                    
                    let x = SMLiveFloat(self.$locationX)
                    let y = SMLiveFloat(self.$locationY)
                    let loc: SMFloat2 = float2(x, y)
                    
                    let cc: SMFloat2 = circleCenter.call(loc, float2(xy.x, xy.y), float2(loc.x + 0.25, loc.y + 0.25))
                    let c: SMFloat = sqrt(pow(xy.x + cc.x, 2) + pow(xy.y + cc.y, 2))//cone.call(cc)
//                    let ccc: SMFloat4 = c < 0.1 <?> float4(1.0) <=> float4(0.0, 0.0, 0.0, 1.0)
                    
                    return float4(c, c, c, 1.0)
                    
                }
            }
        }
            .edgesIgnoringSafeArea(.all)
        .gesture(
            DragGesture()
                .onChanged({ value in
                    let width = Float(UIScreen.main.bounds.width)
                    let height = Float(UIScreen.main.bounds.height)
                    let aspect = width / height
                    let x = Float(value.location.x)
                    let y = Float(value.location.y)
                    let u = x / width
                    let v = y / height
                    self.locationX = (u - 0.5) * aspect
                    self.locationY = v - 0.5
                    print(self.locationX, self.locationY)
                })
        )
    }
}

struct CirclesView_Previews: PreviewProvider {
    static var previews: some View {
        CirclesView()
//            .previewLayout(.fixed(width: 750, height: 750))
    }
}
