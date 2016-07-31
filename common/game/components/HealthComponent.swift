//
//  HealthComponent.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/26/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import GameplayKit

class HealthComponent : GKComponent {
    var alive:Bool
    var currentHealth:Float
    var maximumHealth:Float
    
    init(alive:Bool, currentHealth:Float, maximumHealth:Float) {
        self.alive = alive
        self.currentHealth = currentHealth
        self.maximumHealth = maximumHealth
    }
}
