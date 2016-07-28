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
    
    #elseif os(OSX)
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        setup2DOverlay()
    }
    
    override func setFrameSize(newSize: NSSize) {
        super.setFrameSize(newSize)
    }
    
#endif
    
    func setup2DOverlay() {
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

