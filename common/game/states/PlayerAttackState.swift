//
//  PlayerAttackState.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/26/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import GameplayKit

class PlayerAttackState : GKState {
    var player:GKEntity
    var entityManager:EntityManager
    
    init(entityManager:EntityManager, player:GKEntity) {
        self.entityManager = entityManager
        self.player = player
    }

    override func didEnterWithPreviousState(previousState: GKState?) {
        let player = self.player as! PlayerEntity
        player.changeAnimationStateTo(PlayerAnimationState.Attack)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        print("In attack state update")
    }
}