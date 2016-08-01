//
//  EntityManager.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/31/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import SceneKit
import GameplayKit

class EntityManager {
    var player:PlayerEntity?
    let scene:SCNScene
    var navigationGraph:GKGraph
    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    
    lazy var componentSystems: [GKComponentSystem] = {
        let moveSystem = GKComponentSystem(componentClass: MoveComponent.self)
        let stateSystem = GKComponentSystem(componentClass: StateComponent.self)
        let playerControlSystem = GKComponentSystem(componentClass: PlayerControlComponent.self)

        return [playerControlSystem, moveSystem, stateSystem]
    }()
    
    init(scene:SCNScene, navigationGraph:GKGraph) {
        self.scene = scene
        self.navigationGraph = navigationGraph
    }
    
    func add(entity: GKEntity) {
        entities.insert(entity)
        
        if let scnNode = entity.componentForClass(RenderComponent.self)?.node {
            scene.rootNode.addChildNode(scnNode)
        }
        
        for componentSystem in componentSystems {
            componentSystem.addComponentWithEntity(entity)
        }
    }
    
    func remove(entity: GKEntity) {
        if let scnNode = entity.componentForClass(RenderComponent.self)?.node {
            scnNode.removeFromParentNode()
        }
        
        entities.remove(entity)
        toRemove.insert(entity)
    }
    
    func createPlayer() {
        player = PlayerEntity(entityManager: self, name:"Player")
        
        let renderComponent = RenderComponent(node:player!.node, scale:player!.scale, rotation:player!.rotation)
        player!.addComponent(renderComponent)
        
        let physicsComponent = PhysicsComponent(entityManager:self, entity:player!)
        player!.addComponent(physicsComponent)
        
        let playerControlComponent = PlayerControlComponent(maxSpeed: 10.0, maxAcceleration: 1.0, radius: 10.0, entityManager: self)
        player!.addComponent(playerControlComponent)
        
        let stateComponent = StateComponent(entityManager:self, entity:player!)
        player!.addComponent(stateComponent)
        
        let healthComponent = HealthComponent(alive:true, currentHealth:100.0, maximumHealth:100.0)
        player!.addComponent(healthComponent)
        
        if let renderComponent = player!.componentForClass(RenderComponent.self) {
            renderComponent.node.position = SCNVector3Make(-30.0, 0.0, -30.0)
        }
        add(player!)
    }

    
    func createZombie() {
        let zombie = ZombieEntity(entityManager: self, name:"Zombie")
        
        let renderComponent = RenderComponent(node:zombie.node, scale:zombie.scale, rotation:zombie.rotation)
        zombie.addComponent(renderComponent)
        
        let physicsComponent = PhysicsComponent(entityManager:self, entity:zombie)
        zombie.addComponent(physicsComponent)

        let moveComponent = MoveComponent(maxSpeed: 10.0, maxAcceleration: 1.0, radius: 10.0, entityManager: self)
        zombie.addComponent(moveComponent)
        
        let stateComponent = StateComponent(entityManager:self, entity:zombie)
        zombie.addComponent(stateComponent)
        
        let healthComponent = HealthComponent(alive:true, currentHealth:100.0, maximumHealth:100.0)
        zombie.addComponent(healthComponent)
        
        if let renderComponent = zombie.componentForClass(RenderComponent.self) {
            renderComponent.node.position = SCNVector3Make(30.0, 0.0, 30.0)
        }
        add(zombie)
    }

    func update(deltaTime: CFTimeInterval) {
        for componentSystem in componentSystems {
            componentSystem.updateWithDeltaTime(deltaTime)
        }
        
        for curRemove in toRemove {
            for componentSystem in componentSystems {
                componentSystem.removeComponentWithEntity(curRemove)
            }
        }
        toRemove.removeAll()
    }

}



