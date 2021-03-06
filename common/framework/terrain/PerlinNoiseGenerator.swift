//
//  PerlinNoiseGenerator.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 8/10/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import Foundation

class PerlinNoiseGenerator {
    private static let noiseX = 1619
    private static let noiseY = 31337
    private static let noiseSeed = 1013
    
    private var _seed: Int = 1
    
    // -------------------------------------------------------------------------
    
    private func interpolate(a: Double, b: Double, x: Double) ->Double {
        let ft: Double = x * M_PI
        let f: Double = (1.0-cos(ft)) * 0.5
        
        return a*(1.0-f)+b*f
    }
    
    // -------------------------------------------------------------------------
    
    private func findNoise(x: Double, y: Double) ->Double {
        var n = (PerlinNoiseGenerator.noiseX*Int(x) +
            PerlinNoiseGenerator.noiseY*Int(y) +
            PerlinNoiseGenerator.noiseSeed * _seed) & 0x7fffffff
        
        n = (n >> 13) ^ n
        n = (n &* (n &* n &* 60493 + 19990303) + 1376312589) & 0x7fffffff
        
        return 1.0 - Double(n)/1073741824
    }
    
    // -------------------------------------------------------------------------
    
    private func noise(x: Double, y: Double) ->Double {
        let floorX: Double = Double(Int(x))
        let floorY: Double = Double(Int(y))
        
        let s = findNoise(floorX, y:floorY)
        let t = findNoise(floorX+1, y:floorY)
        let u = findNoise(floorX, y:floorY+1)
        let v = findNoise(floorX+1, y:floorY+1)
        
        let i1 = interpolate(s, b:t, x:x-floorX)
        let i2 = interpolate(u, b:v, x:x-floorX)
        
        return interpolate(i1, b:i2, x:y-floorY)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Calculate a noise value for x,y
    
    func valueFor(x: Int32, y: Int32) ->Double {
        let octaves = 2
        let p: Double = 1/2
        let zoom: Double = 6
        var getnoise: Double = 0
        
        for a in 0..<octaves-1 {
            let frequency = pow(2, Double(a))
            let amplitude = pow(p, Double(a))
            
            getnoise += noise((Double(x))*frequency/zoom, y:(Double(y))/zoom*frequency)*amplitude
        }
        
        var value: Double = Double(((getnoise*128.0)+128.0))
        
        if (value > 255) {
            value = 255
        }
        else if (value < 0) {
            value = 0
        }
        
        return value
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    init(seed: Int? = nil) {
        if (seed == nil) {
            _seed = Int(arc4random()) % Int(INT32_MAX)
        }
        else {
            _seed = seed!
        }
    }
    
    // -------------------------------------------------------------------------
    
}