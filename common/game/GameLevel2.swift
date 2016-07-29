//
//  GameLevel2.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/29/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import SceneKit
import SpriteKit

class GameLevel2 : NSObject, GameLevel {
    var scene:SCNScene?
    var scnView:SCNView?
    var previousTime:NSTimeInterval = 0.0
    var deltaTime:NSTimeInterval = 0.0
    
    override init() {
        super.init()
        previousTime = 0.0
        deltaTime = 0.0
    }
    
    func createLevel(scnView:SCNView) -> SCNScene {
        self.scnView = scnView
        
        // create a new scene
        scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        guard let scn = scene else {
            fatalError("Scene not created")
        }
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scn.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scn.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = SKColor.darkGrayColor()
        scn.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        let ship = scn.rootNode.childNodeWithName("ship", recursively: true)!
        
        // animate the 3d object
        ship.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 1)))
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = SKColor.blackColor()
        
        return scn
    }
    
    func renderer(aRenderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
    }
    
    func physicsWorld(world: SCNPhysicsWorld, didBeginContact contact: SCNPhysicsContact) {
        print("Contact between nodes: \(contact.nodeA.name) and \(contact.nodeB.name)")
    }
    
}

//MARK: GameLevel protocol methods
extension GameLevel2 {
    func startLevel() {
    }
    
    func pauseLevel() {
    }
    
    func stopLevel() {
    }
    
    func levelFailed() {
    }
    
    func levelCompleted() {
    }
    
    #if os(OSX)
    func mouseDown(theEvent: NSEvent) {
    }
    
    func mouseUp(theEvent: NSEvent) {
    }
    
    func keyDown(theEvent: NSEvent) {
    }
    
    func keyUp(theEvent: NSEvent) {
    }
    
    #else
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    
    func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    
    func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    
    #endif

}
