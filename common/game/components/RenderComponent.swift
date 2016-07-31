//
//  RenderComponent.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/31/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import GameplayKit
import SceneKit

class RenderComponent: GKComponent {
    
    let node: SCNNode
    
    init(node:SCNNode, scale:SCNVector3, rotation:SCNVector4) {
        self.node = node
        node.scale = scale
        node.rotation = rotation
    }
}
