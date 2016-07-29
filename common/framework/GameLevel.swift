//
//  GameLevel.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/29/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import SceneKit

protocol GameLevel : SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    func createLevel(scnView:SCNView) -> SCNScene
    func startLevel()
    func pauseLevel()
    func stopLevel()
    
    func levelFailed()
    func levelCompleted()
}

