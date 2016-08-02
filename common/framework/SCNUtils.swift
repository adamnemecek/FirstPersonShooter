//
//  Created by Vivek Nagar on 8/15/14.
//  Copyright (c) 2014 Vivek Nagar. All rights reserved.
//

import SceneKit
import SpriteKit
import QuartzCore

class SCNUtils {
    var animationsDict = Dictionary<String, CAAnimation>()
    
    static func degrees2Radians(degrees:Double) -> Double {
        return (M_PI * degrees) / 180.0
    }
    static func radians2Degrees(radians:Double) -> Double {
        return (180.0 * radians) / M_PI
    }
    
    class func labelWithText(text:String, textSize:CGFloat, fontColor:SKColor)->SKLabelNode {
        let fontName:String = "Optima-ExtraBlack"
        let myLabel:SKLabelNode = SKLabelNode(fontNamed: fontName)
        
        myLabel.name = text
        myLabel.text = text
        myLabel.fontSize = textSize;
        myLabel.fontColor = fontColor
        
        return myLabel;
    }

    func loadSceneFile(filename:String) -> (SCNNode, SCNNode) {
        let escene = SCNScene(named:filename)
        let rootNode = escene!.rootNode
        
        let node = SCNNode()
        var mainSkeleton:SCNNode?
        rootNode.enumerateChildNodesUsingBlock({
            child, stop in

            // do something with node or stop
            if let _ = child.skinner {

                mainSkeleton = child.skinner!.skeleton
                stop.memory = true
                node.addChildNode(child.skinner!.skeleton!)
            }
        })
        
        rootNode.enumerateChildNodesUsingBlock({
            child, stop in
            // do something with node or stop
            if let _ = child.geometry {
                node.addChildNode(child)
            }
        })

        return (node, mainSkeleton!)

    }
    
    static func createDebugBox(scene:SCNScene, box:SCNBox, position:SCNVector3=SCNVector3Zero,
                               color:SKColor=SKColor.blueColor(), rotation:SCNVector4=SCNVector4Zero) -> SCNNode
    {
        let geometry = box
        geometry.firstMaterial!.diffuse.contents = color
        let node = SCNNode(geometry: geometry)
        node.position = position
        node.rotation = rotation
        scene.rootNode.addChildNode(node)
        return node
    }

    static func calculateAngleBetweenCameraAndNode(camera:SCNNode, node:SCNNode) -> Double {
        let angle = atan2(Double(camera.position.y - node.position.y), Double(camera.position.z - node.position.z))
        let angleInDegrees = -angle * 180 / M_PI
        //print("ANGLE IN DEGREES is \(angleInDegrees)")
        return angleInDegrees
    }

    static func distance(node1:SCNNode, node2:SCNNode) -> SCNFloat {
        let disp = (node1.position.x - node2.position.x)*(node1.position.x - node2.position.x) + (node1.position.z - node2.position.z)*(node1.position.z - node2.position.z)
        return sqrt(disp)
    }
    
    class func getBoundingBox(node:SCNNode) -> SCNBox {
        
        var min:SCNVector3 = SCNVector3(x: 0, y: 0, z: 0)
        var max:SCNVector3 = SCNVector3(x: 0, y: 0, z: 0)
        
        node.getBoundingBoxMin(&min, max: &max)
        
        let box = SCNBox(width: CGFloat(max.x-min.x), height: CGFloat(max.y-min.y), length: CGFloat(max.z-min.z), chamferRadius: 0.0)
        return box
    }
        
    class func getAngleFromDirection(currentPosition:SCNVector3, target:SCNVector3) -> Float
    {
        let delX = target.x - currentPosition.x;
        let delZ = target.z - currentPosition.z;
        let angleInRadians =  atan2(delX, delZ);
        
        //print("ANGLE IN radians is \(angleInRadians)")
        return Float(angleInRadians)
    }
    

    func cachedAnimationForKey(key:String) -> CAAnimation! {
        return animationsDict[key]
    }

    class func loadAnimationNamed(animationName:String, fromSceneNamed sceneName:String, withSkeletonNode skeletonNode:String) -> CAAnimation!
    {
        var animation:CAAnimation!

        //Load the animation
        let scene = SCNScene(named: sceneName)

        //Grab the node and its animation
        if let node = scene!.rootNode.childNodeWithName(skeletonNode, recursively: true) {
            print ("Animation keys: \(node.animationKeys)")
            animation = node.animationForKey(animationName)
            if(animation == nil) {
                print("No animation for key \(animationName)")
                return nil
            }
        } else {
            return nil
        }
   
        // Blend animations for smoother transitions
        animation.fadeInDuration = 0.1
        animation.fadeOutDuration = 0.1

        return animation;
    }
    
    func loadAndCacheAnimation(daeFile:String, withSkeletonNode skeletonNode:String, withName name:String, forKey key:String) -> CAAnimation
    {
        let anim = self.dynamicType.loadAnimationNamed(name, fromSceneNamed:daeFile, withSkeletonNode:skeletonNode)

        if ((anim) != nil) {
            self.animationsDict[key] = anim
            anim.delegate = self;
        }
        return anim;
    }
   
    func loadAndCacheAnimation(daeFile:String, withSkeletonNode skeletonNode:String, forKey key:String) -> CAAnimation
    {
        return loadAndCacheAnimation(daeFile, withSkeletonNode:skeletonNode, withName:key, forKey:key)
    }
    
}

