//
//  ZombieEntity.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/26/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import SceneKit
import GameplayKit

enum PlayerAnimationState : Int {
    case Die = 0,
    Kick,
    Idle,
    Walk,
    Attack
}

class PlayerEntity : GKEntity {
    var idleNode:SCNNode!
    var walkNode:SCNNode!
    var dyingNode:SCNNode!
    var attackNode:SCNNode!
    var kickNode:SCNNode!
    let scale = Constants.Player.scale
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
        var filename = Constants.Player.assetDirectory + "idle.dae"
        (n, _) = utils.loadSceneFile(filename)
        self.idleNode = n
        
        filename = Constants.Player.assetDirectory + "walking.dae"
        (n, _) = utils.loadSceneFile(filename)
        self.walkNode = n

        filename = Constants.Player.assetDirectory + "punching.dae"
        (n, _) = utils.loadSceneFile(filename)
        self.attackNode = n

        filename = Constants.Player.assetDirectory + "kicking.dae"
        (n, _) = utils.loadSceneFile(filename)
        self.kickNode = n
        
        filename = Constants.Player.assetDirectory + "dying.dae"
        (n, _) = utils.loadSceneFile(filename)
        self.dyingNode = n

    }

    func changeAnimationStateTo(newState:PlayerAnimationState) {
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
        case .Kick:
            node = kickNode
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
    }
    
}