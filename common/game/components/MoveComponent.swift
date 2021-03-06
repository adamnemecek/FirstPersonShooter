//
//  MoveComponent.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/31/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import GameplayKit
import SceneKit

class MoveComponent : GKAgent2D, GKAgentDelegate {
    
    let entityManager: EntityManager
    var points:[vector_float2] = [
        float2(0.0, 25.0),
        float2(25.0, 75.0),
        float2(50.0, 75.0),
        float2(100.0, 100.0),
        float2(175.0, 75.0),
        float2(150.0, 0.0),
        float2(0.0, -100.0),
        float2(-100.0, -50.0),
        float2(-100.0, 0.0),
        float2(-50.0, 25.0)
    ]

    var path:GKPath!
    
    init(maxSpeed: Float, maxAcceleration: Float, radius: Float, entityManager: EntityManager) {
        self.entityManager = entityManager
        super.init()
        delegate = self
        self.maxSpeed = maxSpeed
        self.maxAcceleration = maxAcceleration
        self.radius = radius
        print(self.mass)
        self.mass = 0.01
        
        self.path = GKPath(points: &points, count: 10, radius: 10.0, cyclical: true)
        /*
        let pathNodeArray = createPath(SCNVector3Make(-175.0, 0.0, -150.0), endPosition:SCNVector3Make(175.0, 0.0, 150.0))
        self.path = GKPath(graphNodes: pathNodeArray, radius: 1.0)
         */
    }

    func createPath(startPosition:SCNVector3, endPosition:SCNVector3) -> [GKGraphNode2D] {
        var points:[vector_float2] = [float2(-150, -10), float2(150, -10), float2(150,20), float2(-150, 20)]
        let obstacle = GKPolygonObstacle(points:&points, count:4)
        let graph = GKObstacleGraph(obstacles: [obstacle], bufferRadius: 1.0)
        
        let startPoint:vector_float2 = float2(Float(startPosition.x), Float(startPosition.z))
        let endPoint:vector_float2 = float2(Float(endPosition.x), Float(endPosition.z))

        let startNode = GKGraphNode2D(point: startPoint)
        let endNode = GKGraphNode2D(point: endPoint)
        
        graph.connectNodeUsingObstacles(startNode)
        graph.connectNodeUsingObstacles(endNode)
        
        let mypath = graph.findPathFromNode(startNode, toNode: endNode) as! [GKGraphNode2D]
        
        print("Start node is \(startNode)")
        for node in mypath {
            print("Node in path is \(node)")
        }
        print("End node is \(endNode)")
        return mypath
    }
    
    func agentWillUpdate(agent: GKAgent) {
        //print("In agent will update, position:\(position)")
        guard let renderComponent = entity?.componentForClass(RenderComponent.self) else {
            return
        }
        
        position = float2(Float(renderComponent.node.position.x), Float(renderComponent.node.position.z))
    }
    
    func agentDidUpdate(agent: GKAgent) {
        //print("In agent did update, position:\(position)")
        guard let renderComponent = entity?.componentForClass(RenderComponent.self) else {
            return
        }
        
        let x = SCNFloat(position.x)
        let z = SCNFloat(position.y)
        
        renderComponent.node.position = SCNVector3Make(x, 0, z)
        renderComponent.node.eulerAngles = SCNVector3Make(SCNFloat(M_PI_2), SCNFloat(rotation), 0.0)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)
        
        guard let playerComponent = entityManager.player!.componentForClass(PlayerControlComponent.self) else {
            print("No player agent found")
            return
        }
        guard let renderComponent = entity?.componentForClass(RenderComponent.self) else {
            return
        }
        guard let playerRenderComponent = entityManager.player?.componentForClass(RenderComponent.self) else {
            return
        }
        let distance = SCNUtils.distance(renderComponent.node, node2: playerRenderComponent.node)
        //print("Distance is \(distance)")
        if(distance < 1.0) {
            behavior!.removeAllGoals()
            return
        }
        
        behavior = MoveBehavior(targetSpeed: maxSpeed, seek: playerComponent, avoid: [], path:path)

    }
}



