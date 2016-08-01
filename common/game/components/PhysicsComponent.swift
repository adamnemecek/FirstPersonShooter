//
//  PhysicsComponent.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 8/1/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import SceneKit
import GameplayKit

class PhysicsComponent : GKComponent {
    var node:SCNNode?
    
    init(entityManager:EntityManager, entity:GKEntity) {
        guard let renderComponent = entity.componentForClass(RenderComponent.self) else {
            return
        }
        
        var contactTestBitMask:Int = 0
        var categoryBitMask:Int = 0
        
        if  let character = entity as? PlayerEntity {
            print("Adding Player Physics Body")
            contactTestBitMask = character.contactTestBitMask
            categoryBitMask = character.categoryBitMask
        } else if  let character = entity as? ZombieEntity {
            print("Adding Zombie Physics Body")
            contactTestBitMask = character.contactTestBitMask
            categoryBitMask = character.categoryBitMask
        } else {
            fatalError("Unknown Entity passed to physics component")
        }
        
        let scale = renderComponent.node.scale.x
        
        let box = SCNUtils.getBoundingBox(renderComponent.node)
        let capRadius = scale * SCNFloat(box.width/2.0)
        let capHeight = scale * SCNFloat(box.length)
        print("entity box width:\(box.width) height:\(box.height) length:\(box.length)")
        print("cap radius:\(capRadius), capHeight=\(capHeight)")
        
        node = SCNNode()
        node!.name = renderComponent.node.name! + "-collision"
        node!.position = SCNVector3Make(0.0, SCNFloat(box.length/2), 0.0)
        let geo = SCNCapsule(capRadius: CGFloat(capRadius), height: CGFloat(capHeight))
        let shape2 = SCNPhysicsShape(geometry: geo, options: nil)
        node!.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Kinematic, shape: shape2)
        
        node!.physicsBody!.contactTestBitMask = contactTestBitMask
        node!.physicsBody!.categoryBitMask = categoryBitMask
        
        node!.rotation = renderComponent.node.rotation
        node!.position = renderComponent.node.position
        
    }
    
    
}
