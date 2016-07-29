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

struct Constants {
    struct Configuration {
        static let UseWorkaround = true
    }
    
}