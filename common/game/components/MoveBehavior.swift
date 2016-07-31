//
//  MoveBehavior.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/31/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import GameplayKit
import SpriteKit

class MoveBehavior: GKBehavior {
    
    init(targetSpeed: Float, seek: GKAgent, avoid: [GKAgent]) {
        super.init()
        
        if targetSpeed > 0 {
            
            setWeight(0.1, forGoal: GKGoal(toReachTargetSpeed: targetSpeed))
            
            //setWeight(0.5, forGoal: GKGoal(toSeekAgent: seek))
            
            //setWeight(1.0, forGoal: GKGoal(toAvoidAgents: avoid, maxPredictionTime: 1.0))
            
            //setWeight(1.0, forGoal:GKGoal(toFollowPath: path, maxPredictionTime: 1.0, forward: true))
        }
    }
}
