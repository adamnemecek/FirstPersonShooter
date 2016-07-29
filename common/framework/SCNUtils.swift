//
//  Created by Vivek Nagar on 8/15/14.
//  Copyright (c) 2014 Vivek Nagar. All rights reserved.
//

import SceneKit
import QuartzCore

class SCNUtils {
    var animationsDict = Dictionary<String, CAAnimation>()

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

