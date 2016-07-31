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
            let dead = ZombieDeadState(entityManager:entityManager, enemy:entity)
            
            stateMachine = GKStateMachine(states:[idle, chase, flee, dead])
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
            return
        }
        
        
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        stateMachine?.updateWithDeltaTime(seconds)
    }
}
