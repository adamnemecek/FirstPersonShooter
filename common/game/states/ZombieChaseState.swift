//
//  ZombieChaseState.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/26/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import GameplayKit

class ZombieChaseState : GKState {
    var enemy:GKEntity
    var entityManager:EntityManager
    
    init(entityManager:EntityManager, enemy:GKEntity) {
        self.entityManager = entityManager
        self.enemy = enemy
    }

    override func didEnterWithPreviousState(previousState: GKState?) {
        let zombie = self.enemy as! ZombieEntity
        zombie.changeAnimationStateTo(ZombieAnimationState.Walk)
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
        if(distance < 5.0) {
            self.stateMachine!.enterState(ZombieAttackState.self)
        }

    }
}