//
//  HUDNode.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/29/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import SpriteKit
import GameController

#if os(iOS) || os(tvOS)
    class ProgressView : UIView {
        var strengthScore:Float = 0.0
        
        override init(frame frameRect: CGRect) {
            super.init(frame:frameRect);
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        
        func update(strength:Float) {
            if (strengthScore != strength) {
                strengthScore = strength;
                self.setNeedsDisplay()
            }
        }
        
        override func drawRect(dirtyRect:CGRect) {
            let context = UIGraphicsGetCurrentContext ();
            // The color to fill the rectangle (in this case black)
            CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 1.0);
            // draw the filled rectangle
            CGContextFillRect (context, self.bounds);
            
            var rect = CGRectInset(self.bounds, 1.0, 2.0)
            if (strengthScore <= 0.2) {
                CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);

            } else if (strengthScore <= 0.4) {
                CGContextSetRGBFillColor(context, 1.0, 1.0, 0.0, 1.0);

            } else {
                CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 1.0);
            }
            
            rect.size.width = CGFloat(floor(Float(rect.size.width) * (strengthScore)))
            //UIBezierPath.fillRect(rect)
            // draw the filled rectangle
            CGContextFillRect (context, rect);
            
            
        }
    }

#elseif os(OSX)
    class ProgressView : NSView {
        var strengthScore:Float = 0.0

        override init(frame frameRect: NSRect) {
            super.init(frame:frameRect);
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        
        func update(strength:Float) {
            if (strengthScore != strength) {
                strengthScore = strength;
                self.needsDisplay = true
            }
        }
    
        override func drawRect(dirtyRect:NSRect) {
            NSColor.grayColor().set()
            NSRectFill(self.bounds)
            var rect = NSInsetRect(self.bounds, 1.0, 2.0)
            if (strengthScore <= 0.2) {
                NSColor.redColor().set()
            } else if (strengthScore <= 0.4) {
                NSColor.yellowColor().set()
            } else {
                NSColor.greenColor().set()
            }
    
            rect.size.width = CGFloat(floor(Float(rect.size.width) * (strengthScore)))
            NSBezierPath.fillRect(rect)
            
        }
    }
#endif

class HUDNode : SKNode {
    var size = CGSizeZero
    var overlay:SKScene?
    var healthBar:ProgressView?
    
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
        healthBar!.update(value)
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
            
            let position = CGPointMake(size.width * 0.1, size.height*0.1)
            self.healthBar = self.createHealthBar(position)
            overlayScene.view!.addSubview(healthBar!)
            self.setHealth(1.0)
        #else
            let position = CGPointMake(size.width * 0.1, size.height*0.9)
            self.healthBar = self.createHealthBar(position)
            overlayScene.view!.addSubview(healthBar!)
            self.setHealth(1.0)
        #endif

    }
    
    func removeControls() {
    
    }
    
    private func createHealthBar(position:CGPoint) -> ProgressView {
        let healthView = ProgressView()
        healthView.frame = CGRect(x: position.x, y: position.y, width: 80, height: 20)
        return healthView
    }
    
    
    #if os(iOS)
    func virtualDPadBounds() -> CGRect {
        return CGRect(x: 10.0, y: 10.0, width: 150.0, height: 150.0)
    }

    #else
    #endif
}
