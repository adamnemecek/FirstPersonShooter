//
//  GameScenesManager.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/28/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import SceneKit
import SpriteKit

class GameScenesManager {
    var gameState:GameState = GameState.PreGame
    var scnView:SCNView?
    // Singleton
    static let sharedInstance = GameScenesManager()
    
    private init() {
    }
    
    func setView(view:SCNView) {
        self.scnView = view
    }
    
    func setupLevels() {
        
    }
    
    private func transitionScene(scene:SCNScene) {
        let sceneTransition = SKTransition.moveInWithDirection(.Right, duration: 1.5)
        guard let view = scnView else {
            fatalError("Scene View is not set")
        }
        view.presentScene(scene, withTransition: sceneTransition, incomingPointOfView:nil, completionHandler:nil)
    }
}
