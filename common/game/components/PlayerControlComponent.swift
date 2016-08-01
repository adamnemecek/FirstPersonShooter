//
//  PlayerControlComponent.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/31/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import GameplayKit
import SceneKit

class PlayerControlComponent : GKAgent2D, GKAgentDelegate {
    
    let entityManager: EntityManager
    
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
        guard let renderComponent = entity?.componentForClass(RenderComponent.self) else {
            return
        }
        
        position = float2(Float(renderComponent.node.position.x), Float(renderComponent.node.position.z))
    }
    
    func agentDidUpdate(agent: GKAgent) {
        guard let renderComponent = entity?.componentForClass(RenderComponent.self) else {
            return
        }
        
        let x = SCNFloat(position.x)
        let z = SCNFloat(position.y)
        
        renderComponent.node.position = SCNVector3Make(x, 0, z)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)
        
        if let renderComponent = entity?.componentForClass(RenderComponent.self) {
                        
            let direction = GameScenesManager.sharedInstance.currentLevel!.controllerDirection()
            let speed = 1.0
        
            let delX = SCNFloat(direction.x) * SCNFloat(speed)
            let delZ = SCNFloat(direction.y) * SCNFloat(speed)
            //let delZ = 0.25
        
            if(delX == 0.0 && delZ == 0.0) {
                return
            }
        
            let newPlayerPos = SCNVector3Make(renderComponent.node.position.x+SCNFloat(delX), renderComponent.node.position.y, renderComponent.node.position.z+SCNFloat(delZ))
            let angleDirection = SCNUtils.getAngleFromDirection(renderComponent.node.position, target:newPlayerPos)
        
            //animation snippet
            
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(0.1)
            renderComponent.node.eulerAngles = SCNVector3Make(SCNFloat(M_PI/2), SCNFloat(angleDirection), 0)
            SCNTransaction.commit()
        
            renderComponent.node.position = newPlayerPos
        }

    }

}



