//
//  ZombieAttackState.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 8/1/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import GameplayKit

class ZombieAttackState : GKState {
    var enemy:GKEntity
    var entityManager:EntityManager
    
    init(entityManager:EntityManager, enemy:GKEntity) {
        self.entityManager = entityManager
        self.enemy = enemy
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        let zombie = self.enemy as! ZombieEntity
        zombie.changeAnimationStateTo(ZombieAnimationState.Attack)
        
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        guard let renderComponent = enemy.componentForClass(RenderComponent.self) else {
            return
        }
        guard let playerRenderComponent = entityManager.player?.componentForClass(RenderComponent.self) else {
            return
        }
        
        let distance = SCNUtils.distance(renderComponent.node, node2: playerRenderComponent.node)
        //print("Distance is \(distance)")
        if(distance > 5.0) {
            self.stateMachine!.enterState(ZombieChaseState.self)
        } else {
            if(distance < 2.0) {
                entityManager.player?.receiveHit()
            }
        }

    }
}