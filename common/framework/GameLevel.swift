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
    #if os(OSX)
    func mouseDown(theEvent: NSEvent)
    func mouseUp(theEvent: NSEvent)
    func keyDown(theEvent: NSEvent)
    func keyUp(theEvent: NSEvent)
    #else
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    #endif

}

