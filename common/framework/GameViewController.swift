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
    }
    
}
