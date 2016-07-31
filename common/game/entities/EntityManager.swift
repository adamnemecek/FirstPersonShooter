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
    let scene:SCNScene
    var navigationGraph:GKGraph
    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    
    lazy var componentSystems: [GKComponentSystem] = {
        let moveSystem = GKComponentSystem(componentClass: MoveComponent.self)
        let stateSystem = GKComponentSystem(componentClass: StateComponent.self)
        return [moveSystem, stateSystem]
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



