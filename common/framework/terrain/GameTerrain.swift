//
//  GameTerrain.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 8/10/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import SceneKit
import SpriteKit

typealias TerrainFormula = ((Int32, Int32) -> (Double))
#if os(iOS)
    typealias GameImage = UIImage
#else
    typealias GameImage = NSImage
#endif

class GameTerrain: SCNNode {
    private var _heightScale = 256
    private var _terrainWidth = 32
    private var _terrainLength = 32
    private var _terrainGeometry: SCNGeometry?
    private var _texture: GameImage?
    private var _color = SKColor.whiteColor()

    var formula: TerrainFormula?
    
    // -------------------------------------------------------------------------
    // MARK: - Properties
    
    var length: Int {
        get {
            return _terrainLength
        }
    }
    
    // -------------------------------------------------------------------------
    
    var width: Int {
        get {
            return _terrainLength
        }
    }
    
    // -------------------------------------------------------------------------
    
    var texture: GameImage? {
        get {
            return _texture
        }
        set(value) {
            _texture = value
            
            if (_terrainGeometry != nil && _texture != nil) {
                let material = SCNMaterial()
                material.diffuse.contents = _texture!
                material.diffuse.magnificationFilter = SCNFilterMode.None
                material.diffuse.wrapS = SCNWrapMode.Repeat
                material.diffuse.wrapT = SCNWrapMode.Repeat
                material.diffuse.contentsTransform = SCNMatrix4MakeScale(SCNFloat(_terrainWidth*2), SCNFloat(_terrainLength*2), 1)
                
                _terrainGeometry!.firstMaterial = material
                _terrainGeometry!.firstMaterial!.doubleSided = true
            }
        }
    }
    
    // -------------------------------------------------------------------------
    
    var color: SKColor {
        get {
            return _color
        }
        set(value) {
            _color = value
            
            if (_terrainGeometry != nil) {
                let material = SCNMaterial()
                material.diffuse.contents = _color
                
                _terrainGeometry!.firstMaterial = material
                _terrainGeometry!.firstMaterial!.doubleSided = true
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Terrain formula
    
    func valueFor(x: Int32, y: Int32) ->Double {
        if (formula == nil) {
            return 0.0
        }
        
        return formula!(x, y)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Geometry creation
    
    private func createGeometry() ->SCNGeometry {
        let w: CGFloat = CGFloat(_terrainWidth)
        let h: CGFloat = CGFloat(_terrainLength)
        let scale: Double = Double(_heightScale)
        
        var sources = [SCNGeometrySource]()
        var elements = [SCNGeometryElement]()
        
        let maxElements: Int = _terrainWidth * _terrainLength * 4
        var vertices = [SCNVector3](count:maxElements, repeatedValue: SCNVector3Zero)
        //var vertices = [SCNVector3](repeating:SCNVector3Zero, count:maxElements)
        var normals = [SCNVector3](count:maxElements, repeatedValue:SCNVector3Zero)
        //var normals = [SCNVector3](repeating:SCNVector3Zero, count:maxElements)
        var uvList: [vector_float2] = []
        
        var vertexCount = 0
        let factor: CGFloat = 0.5
        
        for y in 0...Int(h-2) {
            for x in 0...Int(w-1) {
                let topLeftZ = valueFor(Int32(x), y: Int32(y+1)) / scale
                let topRightZ = valueFor(Int32(x+1), y: Int32(y+1)) / scale
                let bottomLeftZ = valueFor(Int32(x), y: Int32(y)) / scale
                let bottomRightZ = valueFor(Int32(x+1), y: Int32(y)) / scale
                
                let topLeft = SCNVector3Make(SCNFloat(x)-SCNFloat(factor), SCNFloat(topLeftZ), SCNFloat(y)+SCNFloat(factor))
                let topRight = SCNVector3Make(SCNFloat(x)+SCNFloat(factor), SCNFloat(topRightZ), SCNFloat(y)+SCNFloat(factor))
                let bottomLeft = SCNVector3Make(SCNFloat(x)-SCNFloat(factor), SCNFloat(bottomLeftZ), SCNFloat(y)-SCNFloat(factor))
                let bottomRight = SCNVector3Make(SCNFloat(x)+SCNFloat(factor), SCNFloat(bottomRightZ), SCNFloat(y)-SCNFloat(factor))
                
                vertices[vertexCount] = bottomLeft
                vertices[vertexCount+1] = topLeft
                vertices[vertexCount+2] = topRight
                vertices[vertexCount+3] = bottomRight
                
                let xf = CGFloat(x)
                let yf = CGFloat(y)
                
                uvList.append(vector_float2(Float(xf/w), Float(yf/h)))
                uvList.append(vector_float2(Float(xf/w), Float((yf+factor)/h)))
                uvList.append(vector_float2(Float((xf+factor)/w), Float((yf+factor)/h)))
                uvList.append(vector_float2(Float((xf+factor)/w), Float(yf/h)))
                
                vertexCount += 4
            }
        }
        
        let source = SCNGeometrySource(vertices: vertices, count: vertexCount)
        sources.append(source)
        
        let geometryData = NSMutableData()
        
        var geometry: CInt = 0
        while (geometry < CInt(vertexCount)) {
            let bytes: [CInt] = [geometry, geometry+2, geometry+3, geometry, geometry+1, geometry+2]
            geometryData.appendBytes(bytes, length: sizeof(CInt.self)*6)
            geometry += 4
        }
        
        let element = SCNGeometryElement(data: geometryData, primitiveType: SCNGeometryPrimitiveType.Triangles, primitiveCount: vertexCount/2, bytesPerIndex: sizeof(CInt.self))
        elements.append(element)
        
        for normalIndex in 0...vertexCount-1 {
            normals[normalIndex] = SCNVector3Make(0, 0, -1)
        }
        sources.append(SCNGeometrySource(normals: normals, count: vertexCount))
        
        let uvData = NSData(bytes: uvList, length: uvList.count * sizeof(vector_float2.self))
        let uvSource = SCNGeometrySource(data: uvData,
                                         semantic: SCNGeometrySourceSemanticTexcoord,
                                         vectorCount: uvList.count,
                                         floatComponents: true,
                                         componentsPerVector: 2,
                                         bytesPerComponent: sizeof(Float.self),
                                         dataOffset: 0,
                                         dataStride: sizeof(vector_float2.self))
        
        sources.append(uvSource)
        
        _terrainGeometry = SCNGeometry(sources: sources, elements: elements)
        
        let material = SCNMaterial()
        material.diffuse.magnificationFilter = SCNFilterMode.None
        material.diffuse.wrapS = SCNWrapMode.Repeat
        material.diffuse.wrapT = SCNWrapMode.Repeat
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(SCNFloat(_terrainWidth*2), SCNFloat(_terrainLength*2), 1)
        material.diffuse.intensity = 1.0
        
        _terrainGeometry!.firstMaterial = material
        _terrainGeometry!.firstMaterial!.doubleSided = true
        
        return _terrainGeometry!
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Create terrain
    
    func create(withImage image: GameImage?) {
        let terrainNode = SCNNode(geometry: createGeometry())
        self.addChildNode(terrainNode)
        
        if (image != nil) {
            self.texture = image
        }
        else {
            self.color = SKColor.greenColor()
        }
    }
    
    // -------------------------------------------------------------------------
    
    func create(withColor color: SKColor) {
        let terrainNode = SCNNode(geometry: createGeometry())
        self.addChildNode(terrainNode)
        
        self.color = color
        
        terrainNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Static, shape: nil)
        terrainNode.name = "terrain"
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    init(width: Int, length: Int, scale: Int) {
        super.init()
        
        _terrainWidth = width
        _terrainLength = length
        _heightScale = scale
    }
    
    // -------------------------------------------------------------------------
    
    required init(coder: NSCoder) {
        fatalError("Not yet implemented")
    }
    
    // -------------------------------------------------------------------------
}