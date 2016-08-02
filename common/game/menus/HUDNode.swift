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
    var healthBar:SKSpriteNode?
    let maxHealth = 100

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    init(scene:SKScene, size:CGSize) {
        super.init()
        self.size = size
        self.overlay = scene
        
        self.addControls()
    }
    
    func setHealth(value:Int) {
        updateHealthBar(healthBar!, withHealthPoints: value)
    }
    
    private func addControls() {
        
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
            
            let position = CGPointMake(size.width * 0.1, size.height*0.9)
            self.healthBar = self.createHealthBar(position)
            self.setHealth(40)
    }
    
    func removeControls() {
        healthBar!.hidden = true
    }
    


    private func createHealthBar(position:CGPoint) -> SKSpriteNode {
        let playerHealthBar = SKSpriteNode()
        
        addChild(playerHealthBar)
        
        playerHealthBar.position = CGPoint(x: position.x, y: position.y)
        return playerHealthBar
    }
    
    
    private func updateHealthBar(node: SKSpriteNode, withHealthPoints hp: Int) {
        let HealthBarWidth: CGFloat = 40
        let HealthBarHeight: CGFloat = 10
        let barSize = CGSize(width: HealthBarWidth, height: HealthBarHeight);
        
        let fillColor = SKColor(red: 113.0/255, green: 202.0/255, blue: 53.0/255, alpha:1)
        let borderColor = SKColor(red: 35.0/255, green: 28.0/255, blue: 40.0/255, alpha:1)
        
        // create drawing context
        #if os(iOS)
        UIGraphicsBeginImageContextWithOptions(barSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        #else
        let spriteImage = NSImage(size: NSMakeSize(HealthBarWidth, HealthBarHeight))
        spriteImage.lockFocus()
        let context = NSGraphicsContext.currentContext()?.CGContext
        #endif
        
        // draw the outline for the health bar
        borderColor.setStroke()
        let borderRect = CGRect(origin: CGPointZero, size: barSize)
        CGContextStrokeRectWithWidth(context, borderRect, 1)
        
        // draw the health bar with a colored rectangle
        fillColor.setFill()
        let barWidth = (barSize.width - 1) * CGFloat(hp) / CGFloat(maxHealth)
        let barRect = CGRect(x: 0.5, y: 0.5, width: barWidth, height: barSize.height - 1)
        CGContextFillRect(context, barRect)
        
        // extract image
        #if os(iOS)
        let spriteImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        #else
        spriteImage.unlockFocus()
        #endif
        
        // set sprite texture and size
        node.texture = SKTexture(image: spriteImage)
        node.size = barSize
    }
    
    #if os(iOS)
    func virtualDPadBounds() -> CGRect {
        return CGRect(x: 10.0, y: 10.0, width: 150.0, height: 150.0)
    }

    #else
    #endif
}
