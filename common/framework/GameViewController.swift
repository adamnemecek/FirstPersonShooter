//
//  GameViewController.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/19/16.
//  Copyright (c) 2016 Vivek Nagar. All rights reserved.
//

import SceneKit
import SpriteKit

#if os(iOS) || os(tvOS)
    typealias ViewController = UIViewController
#elseif os(OSX)
    typealias ViewController = NSViewController
#endif

class GameViewController: ViewController {
    
    var scnView:SCNView!
    
    #if os(OSX)
    @IBOutlet weak var gameView: GameView!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        scnView = GameSceneView(frame:gameView!.frame)
        scnView.translatesAutoresizingMaskIntoConstraints = false
        self.gameView!.addSubview(scnView)
        
        // Create a bottom space constraint
        var constraint = NSLayoutConstraint (item: scnView,
                                             attribute: NSLayoutAttribute.Bottom,
                                             relatedBy: NSLayoutRelation.Equal,
                                             toItem: self.gameView!,
                                             attribute: NSLayoutAttribute.Bottom,
                                             multiplier: 1,
                                             constant: 0)
        // Add the constraint to the view
        self.gameView!.addConstraint(constraint)
        
        // Create a top space constraint
        constraint = NSLayoutConstraint (item: scnView,
                                         attribute: NSLayoutAttribute.Top,
                                         relatedBy: NSLayoutRelation.Equal,
                                         toItem: self.gameView!,
                                         attribute: NSLayoutAttribute.Top,
                                         multiplier: 1,
                                         constant: 0)
        // Add the constraint to the view
        self.gameView!.addConstraint(constraint)
        
        // Create a right space constraint
        constraint = NSLayoutConstraint (item: scnView,
                                         attribute: NSLayoutAttribute.Right,
                                         relatedBy: NSLayoutRelation.Equal,
                                         toItem: self.gameView!,
                                         attribute: NSLayoutAttribute.Right,
                                         multiplier: 1,
                                         constant: 0)
        // Add the constraint to the view
        self.gameView!.addConstraint(constraint)
        
        // Create a left space constraint
        constraint = NSLayoutConstraint (item: scnView,
                                         attribute: NSLayoutAttribute.Left,
                                         relatedBy: NSLayoutRelation.Equal,
                                         toItem: self.gameView!,
                                         attribute: NSLayoutAttribute.Left,
                                         multiplier: 1,
                                         constant: 0)
        // Add the constraint to the view
        self.gameView!.addConstraint(constraint)

        self.setupScene()
    }
    
    #else
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scnView = GameSceneView(frame:self.view.frame, options:nil)
        self.view.addSubview(scnView)
    
        self.setupScene()
        
    }
        
    #endif
    
    private func setupScene() {
        
        let scenesMgr = GameScenesManager.sharedInstance
        scenesMgr.setView(scnView)
        
        scenesMgr.setupLevels()
        
        
        /*
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = SKColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        let ship = scene.rootNode.childNodeWithName("ship", recursively: true)!
        
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
        */
    }
    
}
