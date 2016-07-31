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
    var enemy:GKEntity
    var entityManager:EntityManager
    
    init(entityManager:EntityManager, enemy:GKEntity) {
        self.entityManager = entityManager
        self.enemy = enemy
        
        let idle = ZombieIdleState(entityManager:entityManager, enemy:enemy)
        let chase = ZombieChaseState(entityManager:entityManager, enemy:enemy)
        let flee = ZombieFleeState(entityManager:entityManager, enemy:enemy)
        let dead = ZombieDeadState(entityManager:entityManager, enemy:enemy)
        
        stateMachine = GKStateMachine(states:[idle, chase, flee, dead])
        stateMachine!.enterState(ZombieChaseState.self)
        
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        stateMachine!.updateWithDeltaTime(seconds)
    }
}
