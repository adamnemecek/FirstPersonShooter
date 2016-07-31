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
        
    }

    func agentWillUpdate(agent: GKAgent) {
        print("In agent will update, position:\(position)")
        guard let renderComponent = entity?.componentForClass(RenderComponent.self) else {
            return
        }
        
        position = float2(Float(renderComponent.node.position.x), Float(renderComponent.node.position.z))
    }
    
    func agentDidUpdate(agent: GKAgent) {
        print("In agent did update, position:\(position)")
        guard let renderComponent = entity?.componentForClass(RenderComponent.self) else {
            return
        }
        
        let x = SCNFloat(position.x)
        let z = SCNFloat(position.y)
        
        renderComponent.node.position = SCNVector3Make(x, 0, z)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)
        behavior = MoveBehavior(targetSpeed: maxSpeed, seek: self, avoid: [])
    }

}



