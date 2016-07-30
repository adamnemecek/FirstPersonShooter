//
//  GameLevel0.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/29/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import SceneKit
import SpriteKit
import GameController

private enum KeyboardDirection : UInt16 {
    case left   = 123
    case right  = 124
    case down   = 125
    case up     = 126
    
    var vector : float2 {
        switch self {
        case .up:    return float2( 0, -1)
        case .down:  return float2( 0,  1)
        case .left:  return float2(-1,  0)
        case .right: return float2( 1,  0)
        }
    }
}


class GameLevel0 : NSObject, GameLevel {
    var scene:SCNScene?
    var scnView:SCNView?
    var hudNode:HUDNode?
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
        
        self.addHUD()
        self.setupGameControllers()
        return scn
    }
    
    func renderer(aRenderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        let direction = self.controllerDirection()
        print("Direction is \(direction)")
    }
    
    func physicsWorld(world: SCNPhysicsWorld, didBeginContact contact: SCNPhysicsContact) {
        print("Contact between nodes: \(contact.nodeA.name) and \(contact.nodeB.name)")
    }
    
    private func addHUD() {
        guard let view = scnView else {
            fatalError("Scene not created")
        }
        
        guard let overlayScene = view.overlaySKScene else {
            print("No overlay scene")
            return
        }
        self.hudNode = HUDNode(scene:overlayScene, size: overlayScene.size)
        overlayScene.addChild(hudNode!)
    }
    
    //Input Handling (keyboard/mouse/touches/Gamepad)

    internal var controllerDPad: GCControllerDirectionPad?
    internal var controllerStoredDirection = float2(0.0) // left/right up/down
    let controllerAcceleration = Float(1.0 / 10.0)
    let controllerDirectionLimit = float2(1.0)
    
    func setupGameControllers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleControllerDidConnectNotification(_:)), name: GCControllerDidConnectNotification, object: nil)
    }
    
    func controllerDirection() -> float2 {
        // Poll when using a game controller
        if let dpad = controllerDPad {
            if dpad.xAxis.value == 0.0 && dpad.yAxis.value == 0.0 {
                controllerStoredDirection = float2(0.0)
            } else {
                controllerStoredDirection = clamp(controllerStoredDirection + float2(dpad.xAxis.value, -dpad.yAxis.value) * controllerAcceleration, min: -controllerDirectionLimit, max: controllerDirectionLimit)
            }
        }
        
        return controllerStoredDirection
    }
    
    func setControllerDirection(direction:float2) {
        controllerStoredDirection = direction
    }
    
    @objc func handleControllerDidConnectNotification(notification: NSNotification) {
        let gameController = notification.object as! GCController
        registerCharacterMovementEvents(gameController)
    }
    
    private func registerCharacterMovementEvents(gameController: GCController) {
        
        // An analog movement handler for D-pads and thumbsticks.
        let movementHandler: GCControllerDirectionPadValueChangedHandler = { [unowned self] dpad, _, _ in
            self.controllerDPad = dpad
        }
        
        #if os(tvOS)
            
            // Apple TV remote
            if let microGamepad = gameController.microGamepad {
                // Allow the gamepad to handle transposing D-pad values when rotating the controller.
                microGamepad.allowsRotation = true
                microGamepad.dpad.valueChangedHandler = movementHandler
            }
            
        #endif
        
        // Gamepad D-pad
        if let gamepad = gameController.gamepad {
            gamepad.dpad.valueChangedHandler = movementHandler
        }
        
        // Extended gamepad left thumbstick
        if let extendedGamepad = gameController.extendedGamepad {
            extendedGamepad.leftThumbstick.valueChangedHandler = movementHandler
        }
    }

    
    #if os(OSX)
    func mouseDown(theEvent: NSEvent) {
        guard let view = scnView else {
            fatalError("Scene not created")
        }
        
        guard let overlayScene = view.overlaySKScene else {
            print("No overlay scene")
            return
        }
        
        guard let hud = hudNode else {
            return
        }
        let location:CGPoint = theEvent.locationInNode(hud)
        let node:SKNode = overlayScene.nodeAtPoint(location)
        if let _ = node.name { // Check if node name is not nil
        }
    }
    
    func mouseUp(theEvent: NSEvent) {
    }
    
    func keyDown(theEvent: NSEvent) {
        if(theEvent.keyCode == 36) {
            // Return Key
            return
        }
        if let direction = KeyboardDirection(rawValue: theEvent.keyCode) {
            if !theEvent.ARepeat {
                //print(direction.vector)
                self.controllerStoredDirection += direction.vector
            }
            return
        }
        return
    }
    
    func keyUp(theEvent: NSEvent) {
        if let direction = KeyboardDirection(rawValue: theEvent.keyCode) {
            if !theEvent.ARepeat {
                //print(direction.vector)
                self.controllerStoredDirection -= direction.vector
            }
            return
        }
        return
    }
    
    #else
    internal var padTouch: UITouch?
    internal var panningTouch: UITouch?

    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let hud = hudNode else {
            return
        }
        for touch in touches {
            let location:CGPoint = touch.locationInNode(hud.scene!)
            let node:SKNode = hud.scene!.nodeAtPoint(location)
            
            if hud.virtualDPadBounds().contains(location) {
                // We're in the dpad
                if padTouch == nil {
                    padTouch = touch
                    controllerStoredDirection = float2(0.0)
                }
            } else if let _ = node.name { // Check if node name is not nil
                break
            } else if panningTouch == nil {
                // Start panning
                panningTouch = touches.first
            }
            
            if padTouch != nil && panningTouch != nil {
                break // We already have what we need
            }

        }
    }
    
    func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let hud = hudNode else {
            return
        }
        if let touch = panningTouch {
            print("PAN CAMERA")
            let loc1 = touch.locationInNode(hud.scene!)
            let loc2 = touch.previousLocationInNode(hud.scene!)
            let disp = CGPoint(x: (loc1.x-loc2.x), y: (loc1.y - loc2.y))
            let displacement = float2(SCNFloat(disp.x), SCNFloat(disp.y))
            //panCamera(displacement)
        }
        
        if let touch = padTouch {
            let direction = controllerStoredDirection
            let loc1 = touch.locationInNode(hud.scene!)
            let loc2 = touch.previousLocationInNode(hud.scene!)
            let disp = CGPoint(x: (loc1.x-loc2.x), y: (loc1.y - loc2.y))
            let displacement = float2(SCNFloat(disp.x), SCNFloat(disp.y))
            controllerStoredDirection = clamp(mix(direction, displacement, t: controllerAcceleration), min: -controllerDirectionLimit, max: controllerDirectionLimit)
            print("Direction is \(controllerStoredDirection)")
            
        }

    }

    func commonTouchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = panningTouch {
            if touches.contains(touch) {
                panningTouch = nil
            }
        }
        
        if let touch = padTouch {
            if touches.contains(touch) {
                padTouch = nil
                controllerStoredDirection = float2(0.0)
            }
        }

    }
    
    func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        commonTouchesEnded(touches, withEvent: event)
    }

    
    #endif
    

}

//MARK: GameLevel protocol methods
extension GameLevel0 {
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
    
    
    
}
