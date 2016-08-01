//
//  GameConstants.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/28/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import SceneKit

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

enum KeyboardDirection : UInt16 {
    case left   = 123
    case right  = 124
    case down   = 125
    case up     = 126

    var vector : float2 {
        switch self {
        case .up:    return float2( 0, -1)
        case .down:  return float2( 0,  1)
        case .left:  return float2(-1,  0)
        case .right: return float2( 1,  0)
        }
    }
}

struct Constants {
    
    struct GameEvents {
        static let HEALTH_LOW = "HealthLow"
        static let HEALTH_CHANGED = "HealthChanged"
        static let PLAYER_DEAD = "PlayerDead"
        static let LEVEL_COMPLETE = "LevelComplete"
        static let GAME_STARTED = "GameStarted"
        static let ENEMY_DESTROYED = "EnemyDestroyed"
        static let LEVEL_ENDED = "LevelEnded"
        static let AMMO_COLLECTED = "AmmoCollected"
        static let HEALTH_RESTORED = "HealthRestored"
        static let RESPAWNED = "Respawned"
        static let GAME_SAVED = "GameSaved"
        static let GAME_LOADED = "GameLoaded"
        static let CRITICAL_ERROR = "CriticalError"
        static let POWERUP_ACQUIRED = "PowerUpAcquired"
    }

    struct Player {
        static let assetDirectory = "art.scnassets/common/models/player/"
        static let scale = SCNVector3Make(0.025, 0.025, 0.025)
    }
    
    struct Zombie {
        static let assetDirectory = "art.scnassets/common/models/zombie/"
        static let scale = SCNVector3Make(0.2, 0.2, 0.2)
    }
    
}
