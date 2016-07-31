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
        if let healthComponent = enemy.componentForClass(HealthComponent.self) {
            healthComponent.currentHealth = healthComponent.currentHealth - 0.01
            if healthComponent.alive == false {
                print("Zombie is not alive")
                self.stateMachine!.enterState(ZombieDeadState.self)
                return
            } else {
                if(healthComponent.currentHealth <= 0.0) {
                    self.stateMachine!.enterState(ZombieDeadState.self)
                    return
                }
                //print("Zombie health is \(healthComponent.currentHealth)")
            }
        }
        
    }
}