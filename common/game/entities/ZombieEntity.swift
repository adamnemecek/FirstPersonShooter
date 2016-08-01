//
//  ZombieEntity.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/26/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import SceneKit
import GameplayKit

enum ZombieAnimationState : Int {
    case Die = 0,
    Run,
    Idle,
    Walk,
    Attack
}

class ZombieEntity : GKEntity {
    let contactTestBitMask =
    ColliderType.FrontWall.rawValue | ColliderType.LeftWall.rawValue | ColliderType.RightWall.rawValue | ColliderType.BackWall.rawValue | ColliderType.Player.rawValue | ColliderType.Door.rawValue | ColliderType.Ground.rawValue | ColliderType.Bullet.rawValue
    
    // Put ourself into the player category so other objects can limit their scope of collision checks.
    let categoryBitMask = ColliderType.Enemy.rawValue;

    var idleNode:SCNNode!
    var walkNode:SCNNode!
    var dyingNode:SCNNode!
    var attackNode:SCNNode!
    var crawlNode:SCNNode!
    let scale = Constants.Zombie.scale
    let rotation = SCNVector4Make(1, 0, 0, SCNFloat(M_PI/2))
    
    var utils = SCNUtils()
    let entityManager:EntityManager
    var node:SCNNode!
    
    init(entityManager: EntityManager, name:String) {
        self.entityManager = entityManager
        super.init()

        self.loadAnimations()

        node = idleNode
        node.name = name
    }
    
    func loadAnimations() {
        var n:SCNNode
        var filename = Constants.Zombie.assetDirectory + "idle.dae"
        (n, _) = utils.loadSceneFile(filename)
        self.idleNode = n
        
        filename = Constants.Zombie.assetDirectory + "walk.dae"
        (n, _) = utils.loadSceneFile(filename)
        self.walkNode = n

        filename = Constants.Zombie.assetDirectory + "attack.dae"
        (n, _) = utils.loadSceneFile(filename)
        self.attackNode = n

        filename = Constants.Zombie.assetDirectory + "crawl.dae"
        (n, _) = utils.loadSceneFile(filename)
        self.crawlNode = n
        
        filename = Constants.Zombie.assetDirectory + "dying.dae"
        (n, _) = utils.loadSceneFile(filename)
        self.dyingNode = n

    }

    func changeAnimationStateTo(newState:ZombieAnimationState) {
        let lastPosition = node.position
        let currentNode = node
        switch(newState) {
        case .Idle:
            node = idleNode
            break
        case .Walk:
            node = walkNode
            break
        case .Attack:
            node = attackNode
            break
        case .Run:
            node = crawlNode
            break
        case .Die:
            node = dyingNode
            break
        }
        
        if let _ = self.componentForClass(RenderComponent.self) {
            self.removeComponentForClass(RenderComponent.self)
            currentNode.removeFromParentNode()
        }
        
        let renderComponent = RenderComponent(node:node, scale:scale, rotation:rotation)
        renderComponent.node.position = lastPosition
        self.addComponent(renderComponent)
        entityManager.scene.rootNode.addChildNode(node)
        
        if let physicsBody = self.componentForClass(PhysicsComponent.self) {
            node.addChildNode(physicsBody.node!)
        }
    }
    
}