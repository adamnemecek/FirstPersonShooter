//
//  ZombieDeadState.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/26/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import GameplayKit

class ZombieDeadState : GKState {
    var enemy:GKEntity
    var entityManager:EntityManager
    
    init(entityManager:EntityManager, enemy:GKEntity) {
        self.entityManager = entityManager
        self.enemy = enemy
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        let zombie = self.enemy as! ZombieEntity
        zombie.changeAnimationStateTo(ZombieAnimationState.Die)
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        self.entityManager.remove(enemy)
    }
}