//
//  PlayerChaseState.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/26/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import GameplayKit

class PlayerWalkState : GKState {
    var player:GKEntity
    var entityManager:EntityManager
    
    init(entityManager:EntityManager, player:GKEntity) {
        self.entityManager = entityManager
        self.player = player
    }

    override func didEnterWithPreviousState(previousState: GKState?) {
        let player = self.player as! PlayerEntity
        player.changeAnimationStateTo(PlayerAnimationState.Walk)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        let player = self.player as! PlayerEntity
        
        if let healthComponent = player.componentForClass(HealthComponent.self) {
            healthComponent.currentHealth = healthComponent.currentHealth - 0.01
            if healthComponent.alive == false {
                print("Player is not alive")
                self.stateMachine!.enterState(PlayerDeadState.self)
                return
            } else {
                if(healthComponent.currentHealth <= 0.0) {
                    self.stateMachine!.enterState(PlayerDeadState.self)
                    return
                }
                //print("Player health is \(healthComponent.currentHealth)")
            }
        }
        
        let direction = GameScenesManager.sharedInstance.currentLevel!.controllerDirection()

        if(direction.x == 0.0 && direction.y == 0.0 ) {
            self.stateMachine!.enterState(PlayerIdleState.self)
            return
        }
        
    }
}
