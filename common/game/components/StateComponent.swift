//
//  StateComponent.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/31/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import GameplayKit

class StateComponent: GKComponent {
    
    var stateMachine:GKStateMachine?
    var entityManager:EntityManager
    
    init(entityManager:EntityManager, entity:GKEntity) {
        self.entityManager = entityManager
        
        if let _ = entity as? ZombieEntity {
            let idle = ZombieIdleState(entityManager:entityManager, enemy:entity)
            let chase = ZombieChaseState(entityManager:entityManager, enemy:entity)
            let flee = ZombieFleeState(entityManager:entityManager, enemy:entity)
            let attack = ZombieAttackState(entityManager:entityManager, enemy:entity)
            let dead = ZombieDeadState(entityManager:entityManager, enemy:entity)
            
            stateMachine = GKStateMachine(states:[idle, chase, flee, attack, dead])
            stateMachine!.enterState(ZombieChaseState.self)

        }
        else if let _ = entity as? PlayerEntity {
            
            let idle = PlayerIdleState(entityManager:entityManager, player:entity)
            let walk = PlayerWalkState(entityManager:entityManager, player:entity)
            let attack = PlayerAttackState(entityManager:entityManager, player:entity)
            let dead = PlayerDeadState(entityManager:entityManager, player:entity)
            
            stateMachine = GKStateMachine(states:[idle, walk, attack, dead])
            stateMachine!.enterState(PlayerIdleState.self)
            
        } else {
        }
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.attackNotificationReceived), name: Constants.GameEvents.ATTACK_ENEMY, object: nil)
    }
    
    func attackNotificationReceived() {
        stateMachine!.enterState(PlayerAttackState.self)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        if let player = entity as? PlayerEntity {
            if let healthComponent = player.componentForClass(HealthComponent.self) {
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
            if(player.missionAccomplished) {
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.GameEvents.LEVEL_COMPLETE, object: nil)
            }
        } else if let zombie = entity as? ZombieEntity {
            if let healthComponent = zombie.componentForClass(HealthComponent.self) {
                if healthComponent.alive == false {
                    self.stateMachine!.enterState(ZombieDeadState.self)
                    return
                } else {
                    if(healthComponent.currentHealth <= 0.0) {
                        self.stateMachine!.enterState(ZombieDeadState.self)
                        return
                    }
                }
            }

        }

        stateMachine?.updateWithDeltaTime(seconds)
    }
}
