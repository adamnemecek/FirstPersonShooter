//
//  GameCamera.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/30/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import SceneKit
import GLKit

class GameCamera : SCNNode {
    
    override init() {
        super.init()
        self.camera = SCNCamera()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func turnCameraAroundNode(node:SCNNode, radius:CGFloat, angleInDegrees:Float)
    {
        let animation = CAKeyframeAnimation(keyPath:"transform")
        animation.duration = 15.0
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        
        var animValues = [NSValue]()
        for index in 0.stride(to: 360, by: 1) {
            let hAngle = Double(index) * M_PI / 180.0
            let vAngle = Double(angleInDegrees) * M_PI / 180.0
            let val = NSValue(CATransform3D: transformationToRotateAroundPosition(node.position, radius:radius, horizontalAngle:CGFloat(hAngle), verticalAngle:CGFloat(vAngle)))
            animValues.append(val)
        }
        
        animation.values = animValues;
        animation.timingFunction = CAMediaTimingFunction (name: kCAMediaTimingFunctionEaseInEaseOut);
        self.addAnimation(animation, forKey:"animation");
        
    }
    
    private func transformationToRotateAroundPosition(center:SCNVector3! ,radius:CGFloat, horizontalAngle:CGFloat, verticalAngle:CGFloat) -> CATransform3D
    {
        let rad:SCNFloat = SCNFloat(radius)
        let vertAngle:SCNFloat = SCNFloat(verticalAngle)
        let horAngle:SCNFloat = SCNFloat(horizontalAngle)
        
        
        var pos:SCNVector3 = SCNVector3Make(0, 0, 0)
        pos.x = center.x + rad * cos(vertAngle) * sin(horAngle)
        pos.y = self.position.y;
        pos.z = center.z + rad * cos(vertAngle) * cos(horAngle)
        
        let rotX = CATransform3DMakeRotation(CGFloat(verticalAngle), 1, 0, 0)
        let rotY = CATransform3DMakeRotation(CGFloat(horizontalAngle), 0, 1, 0)
        let rotation = CATransform3DConcat(rotX, rotY)
        
        let translate = CATransform3DMakeTranslation(CGFloat(pos.x), CGFloat(pos.y), CGFloat(pos.z))
        let transform = CATransform3DConcat(rotation,translate)
        
        return transform;
    }
    
}
