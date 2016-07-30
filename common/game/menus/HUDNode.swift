//
//  HUDNode.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/29/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import SpriteKit
import GameController


class HUDNode : SKNode {
    var size = CGSizeZero
    var overlay:SKScene?
    var healthBar:UIProgressView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    init(scene:SKScene, size:CGSize) {
        super.init()
        self.size = size
        self.overlay = scene
        
        self.addControls()
    }
    
    func setHealth(value:Float) {
        healthBar!.progress = value
        if(value <= 0.2) {
            healthBar!.progressTintColor = SKColor.redColor()
        } else {
            healthBar!.progressTintColor = SKColor.greenColor()
        }
    }
    
    private func addControls() {
        guard let overlayScene = overlay else {
            print("No overlay scene")
            return
        }

        // The virtual D-pad
        #if os(iOS)
            let dpadSprite = SKSpriteNode(imageNamed: "art.scnassets/overlays/dpad")
            dpadSprite.position = CGPointMake(size.width * 0.15, size.height*0.2)
            dpadSprite.name = "dpad"
            dpadSprite.zPosition = 1.0
            dpadSprite.setScale(0.4)
            self.addChild(dpadSprite)
            
            let attackSprite = SKSpriteNode(imageNamed: "art.scnassets/overlays/dpad")
            attackSprite.position = CGPointMake(size.width * 0.85, size.height*0.2)
            attackSprite.name = "attackNode"
            attackSprite.zPosition = 1.0
            attackSprite.setScale(0.4)
            self.addChild(attackSprite)
        #endif

        self.healthBar = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
        healthBar!.center = CGPoint(x: 100, y: 50)
        healthBar!.transform = CGAffineTransformMakeScale(1.0, 6.0)
        healthBar!.progressTintColor = SKColor.greenColor()
        healthBar!.trackTintColor = SKColor.grayColor()
        overlayScene.view!.addSubview(healthBar!)
        self.setHealth(0.4)

    }
    
    #if os(iOS)
    func virtualDPadBounds() -> CGRect {
        return CGRect(x: 10.0, y: 10.0, width: 150.0, height: 150.0)
    }
    #endif
}
