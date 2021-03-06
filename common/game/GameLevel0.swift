//
//  GameLevel0.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/29/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import SceneKit
import SpriteKit
import GameplayKit
import GameController


class GameLevel0 : NSObject, GameLevel {
    
    var scene:SCNScene?
    var scnView:SCNView?
    var hudNode:HUDNode?
    
    var sceneCamera:GameCamera?
    var previousTime:NSTimeInterval = 0.0
    var deltaTime:NSTimeInterval = 0.0
    
    var debugNode:SCNNode?
    var entityManager: EntityManager?
    var firstPerson = true
    
    override init() {
        super.init()
        previousTime = 0.0
        deltaTime = 0.0
    }
    
    func createLevel(scnView:SCNView) -> SCNScene {
        self.scnView = scnView
        
        // create a new scene
        scene = SCNScene()
        
        guard let scn = scene else {
            fatalError("Scene not created")
        }
        
        // create and add a camera to the scene
        self.sceneCamera = GameCamera()
        sceneCamera!.camera?.zFar = 500.0
        scn.rootNode.addChildNode(sceneCamera!)
        
        // place the camera
        sceneCamera!.position = SCNVector3(x: 0, y: 110, z: 200)
        sceneCamera!.rotation = SCNVector4Make(1.0, 0.0, 0.0, -SCNFloat(M_PI_4))

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
        
        self.addFloorAndWalls()
        self.addProps()
        
        //scnView.allowsCameraControl = true
        
        self.addHUD()
        self.setupGameControllers()
        
        let graph = GKGridGraph(fromGridStartingAt: (vector_int2)(0,0), width: 64, height: 64, diagonalsAllowed: false)
        entityManager = EntityManager(scene: self.scene!, navigationGraph:graph)
        entityManager!.createZombie()
        entityManager!.createPlayer()
        return scn
    }
    
    func renderer(aRenderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        if(previousTime == 0.0) {
            previousTime = time
        }
        deltaTime = time - previousTime
        previousTime = time
        
        _ = self.controllerDirection()
        //print("Direction is \(direction)")
        
        entityManager?.update(deltaTime)
        
    }
    
    func physicsWorld(world: SCNPhysicsWorld, didBeginContact contact: SCNPhysicsContact) {
        print("Contact between nodes: \(contact.nodeA.name) and \(contact.nodeB.name)")
    }
    
    private func addFloorAndWalls() {
        //add floor
        let floorNode = SCNNode()
        let floor = SCNFloor()
        floor.reflectionFalloffEnd = 2.0
        floorNode.geometry = floor
        floorNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/level0/wood.png"
        floorNode.geometry?.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(2, 2, 1); //scale the wood texture
        floorNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
        floorNode.physicsBody = SCNPhysicsBody.staticBody()
        scene?.rootNode.addChildNode(floorNode)

        //add walls
        var wall = SCNNode(geometry:SCNBox(width:400, height:100, length:4, chamferRadius:0))
        wall.geometry!.firstMaterial!.diffuse.contents = "art.scnassets/level0/wall.jpg"
        wall.geometry!.firstMaterial!.diffuse.contentsTransform = SCNMatrix4Mult(SCNMatrix4MakeScale(24, 2, 1), SCNMatrix4MakeTranslation(0, 1, 0));
        wall.geometry!.firstMaterial!.diffuse.wrapS = SCNWrapMode.Repeat;
        wall.geometry!.firstMaterial!.diffuse.wrapT = SCNWrapMode.Mirror;
        wall.geometry!.firstMaterial!.doubleSided = false;
        wall.castsShadow = false;
        wall.geometry!.firstMaterial!.locksAmbientWithDiffuse = true;
        
        wall.position = SCNVector3Make(0, 50, -198);
        wall.name = "FrontWall"
        wall.physicsBody = SCNPhysicsBody.staticBody()
        wall.physicsBody!.collisionBitMask = ColliderType.Player.rawValue | ColliderType.Enemy.rawValue
        wall.physicsBody!.categoryBitMask = ColliderType.FrontWall.rawValue
        scene?.rootNode.addChildNode(wall)
        
        wall = wall.clone()
        wall.position = SCNVector3Make(-202, 50, 0);
        wall.name = "LeftWall"
        wall.rotation = SCNVector4Make(0.0, 1.0, 0.0, SCNFloat(M_PI_2));
        wall.physicsBody = SCNPhysicsBody.staticBody()
        wall.physicsBody!.collisionBitMask = ColliderType.Player.rawValue | ColliderType.Enemy.rawValue
        wall.physicsBody!.categoryBitMask = ColliderType.LeftWall.rawValue
        scene?.rootNode.addChildNode(wall)
        
        wall = wall.clone()
        wall.position = SCNVector3Make(202, 50, 0);
        wall.name = "RightWall"
        wall.rotation = SCNVector4Make(0.0, 1.0, 0.0, -SCNFloat(M_PI_2));
        wall.physicsBody = SCNPhysicsBody.staticBody()
        wall.physicsBody!.collisionBitMask = ColliderType.Player.rawValue | ColliderType.Enemy.rawValue
        wall.physicsBody!.categoryBitMask = ColliderType.RightWall.rawValue
        scene?.rootNode.addChildNode(wall)
        
        let backWall = SCNNode(geometry:SCNPlane(width:400, height:100))
        backWall.name = "BackWall"
        backWall.geometry!.firstMaterial = wall.geometry!.firstMaterial;
        backWall.position = SCNVector3Make(0, 50, 198);
        backWall.rotation = SCNVector4Make(0.0, 1.0, 0.0, SCNFloat(M_PI));
        backWall.castsShadow = false;
        backWall.physicsBody = SCNPhysicsBody.staticBody()
        wall.physicsBody!.collisionBitMask = ColliderType.Player.rawValue | ColliderType.Enemy.rawValue
        wall.physicsBody!.categoryBitMask = ColliderType.BackWall.rawValue
        scene?.rootNode.addChildNode(backWall)
        
        // add ceiling
        let ceilNode = SCNNode(geometry:SCNPlane(width:400, height:400))
        ceilNode.position = SCNVector3Make(0, 100, 0);
        ceilNode.rotation = SCNVector4Make(1.0, 0.0, 0.0, SCNFloat(M_PI_2));
        ceilNode.geometry!.firstMaterial!.doubleSided = false;
        ceilNode.castsShadow = false
        ceilNode.geometry!.firstMaterial!.locksAmbientWithDiffuse = true;
        scene?.rootNode.addChildNode(ceilNode)
    }
    
    private func addProps() {
        self.debugNode = SCNUtils.createDebugBox(self.scene!, box:SCNBox(width: 20.0, height: 20.0, length: 20.0, chamferRadius: 1.0), position:SCNVector3(-150.0, 0.0, -10.0))
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
    
    func registerListeners() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.playerDeadNotification), name: Constants.GameEvents.PLAYER_DEAD, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.healthLowNotification), name: Constants.GameEvents.HEALTH_LOW, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.successfulCompletion), name: Constants.GameEvents.LEVEL_COMPLETE, object: nil)
    }
    
    func unregisterListeners() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Constants.GameEvents.PLAYER_DEAD, object:nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Constants.GameEvents.HEALTH_LOW, object:nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Constants.GameEvents.LEVEL_COMPLETE, object:nil)
        
        
    }
    
    func playerDeadNotification() {
        print("Received player dead notification")
        self.levelFailed()
    }
    
    func healthLowNotification() {
        print("Received health low notification")
    }
    
    func successfulCompletion() {
        self.levelCompleted()
    }

    private func setupSounds() {
        let backgroundMusicSource = SCNAudioSource(named: "art.scnassets/sounds/background_music.m4a")
        backgroundMusicSource!.volume = 0.2
        let player = SCNAudioPlayer(source:backgroundMusicSource!)
        backgroundMusicSource!.loops = true
        backgroundMusicSource!.shouldStream = true
        backgroundMusicSource!.positional = false
        self.scene!.rootNode.addAudioPlayer(player)
    }

    
    private func panCamera(displacement:float2) {
        print("Displacement is \(displacement)")
        if(abs(displacement.x) > abs(displacement.y)) {
            //Need to yaw
            sceneCamera?.eulerAngles.y = (sceneCamera?.eulerAngles.y)! + SCNFloat(SCNUtils.degrees2Radians(Double(displacement.x * 0.05)))
        } else {
            //Need to pitch
            sceneCamera?.eulerAngles.x = (sceneCamera?.eulerAngles.x)! + SCNFloat(SCNUtils.degrees2Radians(Double(displacement.y*0.05)))
        }
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
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.GameEvents.ATTACK_ENEMY, object: nil)
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
            } else if let name = node.name { // Check if node name is not nil
                print("Node NAME is \(name)")
                if (name == "attackNode") {
                    NSNotificationCenter.defaultCenter().postNotificationName(Constants.GameEvents.ATTACK_ENEMY, object: nil)
                }
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
            let loc1 = touch.locationInNode(hud.scene!)
            let loc2 = touch.previousLocationInNode(hud.scene!)
            let disp = CGPoint(x: (loc1.x-loc2.x), y: (loc1.y - loc2.y))
            let displacement = float2(SCNFloat(disp.x), SCNFloat(disp.y))
            if(firstPerson == false) {
                self.panCamera(displacement)
            }
        }
        
        if let touch = padTouch {
            let direction = controllerStoredDirection
            let loc1 = touch.locationInNode(hud.scene!)
            let loc2 = touch.previousLocationInNode(hud.scene!)
            let disp = CGPoint(x: (loc1.x-loc2.x), y: (loc1.y - loc2.y))
            let displacement = float2(SCNFloat(disp.x), SCNFloat(disp.y))
            controllerStoredDirection = clamp(mix(direction, displacement, t: controllerAcceleration), min: -controllerDirectionLimit, max: controllerDirectionLimit)
            //print("Direction is \(controllerStoredDirection)")
            
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
        registerListeners()
        setupSounds()
    }
    
    func pauseLevel() {
    }
    
    func stopLevel() {
        unregisterListeners()
        hudNode?.removeControls()
    }
    
    func levelFailed() {
        unregisterListeners()
        hudNode?.removeControls()
        GameScenesManager.sharedInstance.setGameState(.LevelFailed, levelIndex:0)
    }
    
    func levelCompleted() {
        unregisterListeners()
        hudNode?.removeControls()
        GameScenesManager.sharedInstance.setGameState(.LevelComplete, levelIndex:0)

    }
    
    
    
}
