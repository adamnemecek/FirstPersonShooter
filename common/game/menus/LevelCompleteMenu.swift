//
//  LevelFailedMenu.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/29/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import SceneKit
import SpriteKit

class LevelCompleteMenu : NSObject, GameLevel {
    var scene:SCNScene?
    var scnView:SCNView?
    let labelName = "Level Complete"
    let replayLabelName = "Next Level"
    let mainMenuLabelName = "Main Menu"
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLevel(scnView:SCNView) -> SCNScene  {
        let node:SCNNode = SCNNode()

        self.scnView = scnView

        scene = SCNScene()
        guard let scn = scene else {
            fatalError("Scene not created")
        }
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.zFar = 200.0
        scn.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 120)
    
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 100)
        scn.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        //ambientLightNode.light!.color = SKColor.darkGrayColor()
        ambientLightNode.light!.color = SKColor.grayColor()
        scn.rootNode.addChildNode(ambientLightNode)

        let size = self.scnView!.frame.size
        self.addMenuBlock(node, labelName:labelName, textSize:40, position:CGPointMake(size.width/2, size.height/2 + 40))
        self.addMenuBlock(node, labelName:replayLabelName, textSize:20, position:CGPointMake(size.width/2, size.height/2))
        self.addMenuBlock(node, labelName:mainMenuLabelName, textSize:20, position:CGPointMake(size.width/2, size.height/2 - 40))

        scn.rootNode.addChildNode(node)
        node.position = SCNVector3Make(0.0, 0.0, 0.0)
        
        let utils = SCNUtils()
        let filename = Constants.Zombie.assetDirectory + "walk.dae"
        let n:SCNNode
        (n, _) = utils.loadSceneFile(filename)
        n.scale = SCNVector3Make(0.3, 0.3, 0.3)
        n.rotation = SCNVector4Make(1, 0, 0, SCNFloat(M_PI/2))
        n.position = SCNVector3Make(-40.0, -20.0, 0.0)

        scn.rootNode.addChildNode(n)
        
        // set the scene to the view
        scnView.scene = scene
        return scn
    }
    
    private func addMenuBlock(node:SCNNode, labelName:String, textSize:CGFloat, position:CGPoint) {
        let myLabel1 = SCNUtils.labelWithText(labelName, textSize: textSize, fontColor:SKColor.yellowColor())
        myLabel1.position = position
        self.scnView!.overlaySKScene!.addChild(myLabel1)
    }
    
    func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
    }
    
    
    func physicsWorld(world: SCNPhysicsWorld, didBeginContact contact: SCNPhysicsContact) {
        print("Contact between nodes: \(contact.nodeA.name) and \(contact.nodeB.name)")
    }
    
}

//MARK: GameLevel protocol methods
extension LevelCompleteMenu {
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
    
    func controllerDirection() -> float2 {
        return float2(0.0, 0.0)
    }
    
    #if os(OSX)
    func mouseDown(theEvent: NSEvent) {
        // check what nodes are clicked
        guard let view = scnView else {
            return
        }
        let p = view.convertPoint(theEvent.locationInWindow, fromView: nil)
        self.handleSelection(view, location:p)

    }
    
    func mouseUp(theEvent: NSEvent) {
    }
    
    func keyDown(theEvent: NSEvent) {
    }
    
    func keyUp(theEvent: NSEvent) {
    }
    
    #else
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let view = scnView else {
            return
        }
        if let touch = touches.first {
            let p = touch.locationInView(view)
            self.handleSelection(view, location:p)
        }
    }
    
    func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    
    func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    
    #endif
    
    private func handleSelection(view:SCNView, location:CGPoint) {
        let node:SKNode = (scnView?.overlaySKScene!.nodeAtPoint(location))!
        
        let levelIndex = GameScenesManager.sharedInstance.currentLevelIndex
        if (node.name == self.replayLabelName) {
            GameScenesManager.sharedInstance.setGameState(.InGame, levelIndex:levelIndex+1)
        } else if(node.name == self.mainMenuLabelName) {
            GameScenesManager.sharedInstance.setGameState(.PreGame, levelIndex:levelIndex)
        } else {
            print("Unknown node hit")
        }
    }

}
