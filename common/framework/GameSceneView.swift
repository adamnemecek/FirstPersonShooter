//
//  GameSceneView.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/28/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import SceneKit
import SpriteKit

class GameSceneView : SCNView {
    #if os(iOS)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup2DOverlay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(frame: CGRect, options: [String : AnyObject]?) {
        super.init(frame:frame, options:options)
        setup2DOverlay()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches as Set<UITouch>, withEvent:event)
        GameScenesManager.sharedInstance.touchesBegan(touches as Set<UITouch>, withEvent:event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches as Set<UITouch>, withEvent:event)
        GameScenesManager.sharedInstance.touchesMoved(touches as Set<UITouch>, withEvent:event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches as Set<UITouch>, withEvent:event)
        GameScenesManager.sharedInstance.touchesEnded(touches as Set<UITouch>, withEvent:event)
    }

    
    #elseif os(OSX)
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        setup2DOverlay()
    }
    
    override func setFrameSize(newSize: NSSize) {
        super.setFrameSize(newSize)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        super.mouseDown(theEvent)
        GameScenesManager.sharedInstance.mouseDown(theEvent)
    }
    
    override func mouseUp(theEvent: NSEvent) {
        super.mouseDown(theEvent)
        GameScenesManager.sharedInstance.mouseUp(theEvent)
    }
    
    override func keyDown(theEvent: NSEvent) {
        super.keyDown(theEvent)
        GameScenesManager.sharedInstance.keyDown(theEvent)
    }
    override func keyUp(theEvent: NSEvent) {
        super.keyUp(theEvent)
        GameScenesManager.sharedInstance.keyUp(theEvent)
    }

    
#endif
    
    private func setup2DOverlay() {
        let w = bounds.size.width
        let h = bounds.size.height
        
        // Setup the game overlays using SpriteKit.
        let skScene = SKScene(size: CGSize(width: w, height: h))
        skScene.scaleMode = SKSceneScaleMode.ResizeFill
        
        // Assign the SpriteKit overlay to the SceneKit view.
        overlaySKScene = skScene
        
        //self.debugOptions = SCNDebugOptions.ShowPhysicsShapes
    }
    
}

