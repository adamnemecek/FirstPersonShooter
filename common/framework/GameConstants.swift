//
//  GameConstants.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/28/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import Foundation

#if os(iOS)
    typealias SCNFloat = Float
    let namespace = "FirstPersonShooter_iOS"
#elseif os(tvOS)
    typealias SCNFloat = Float
    let namespace = "FirstPersonShooter_tvOS"
#else
    typealias SCNFloat = CGFloat
    let namespace = "FirstPersonShooter_macOS"
#endif

@objc enum GameState :Int {
    case PreGame=0,
    InGame,
    Paused,
    LevelComplete,
    LevelFailed,
    PostGame
}

enum ColliderType: Int {
    case Ground = 2048
    case Bullet = 4
    case Player = 8
    case Enemy = 16
    case LeftWall = 32
    case RightWall = 64
    case BackWall = 128
    case FrontWall = 256
    case Door = 512
    case PowerUp = 1024
    
}

struct Constants {
    struct Configuration {
        static let UseWorkaround = true
    }
    
    struct Zombie {
        static let assetDirectory = "art.scnassets/common/models/zombie/"
    }
    
}