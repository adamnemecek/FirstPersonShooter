//
//  PlayerDeadState.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/26/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import GameplayKit

class PlayerDeadState : GKState {
    var player:GKEntity
    var entityManager:EntityManager
    
    init(entityManager:EntityManager, player:GKEntity) {
        self.entityManager = entityManager
        self.player = player
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        let player = self.player as! PlayerEntity
        player.changeAnimationStateTo(PlayerAnimationState.Die)
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.GameEvents.PLAYER_DEAD, object: nil)
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        // self.entityManager.remove(enemy)
    }
}
