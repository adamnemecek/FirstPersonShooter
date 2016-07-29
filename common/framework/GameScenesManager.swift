//
//  GameScenesManager.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/28/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import SceneKit
import SpriteKit

class GameScenesManager {
    let levelName = "GameLevel"
    var gameState:GameState = GameState.PreGame
    var scnView:SCNView?
    var gameLevels:[GameLevel] = [GameLevel]()
    var currentLevel:GameLevel?
    var currentLevelIndex:Int = 0
    // Singleton
    static let sharedInstance = GameScenesManager()
    
    private init() {
    }
    
    func setView(view:SCNView) {
        self.scnView = view
    }
    
    func setupLevels() {
        guard let view = scnView else {
            fatalError("Scene View is not set")
        }
        view.backgroundColor = SKColor.grayColor()
        let numLevels = 3
        
        for levelIndex in 0...numLevels-1 {
            let level:GameLevel = initializeGameLevel(levelName + String(levelIndex))
            gameLevels.append(level)
        }
        
        view.scene = SCNScene()
        setGameState(.PreGame, levelIndex:0)
    }
    
    func setGameState(gameState:GameState, levelIndex:Int) {
        guard let view = self.scnView else {
            fatalError("Scene View is not set")
        }
        switch(gameState) {
        case .PreGame:
            currentLevel = initializeGameLevel("GameLevelsMenu")
            let newScene = setupGameLevel(currentLevel!)
            self.transitionScene(newScene)
            view.scene!.rootNode.hidden = false
            currentLevel!.startLevel()
            view.play(self)
            break;
        case .InGame:
            currentLevelIndex = levelIndex
            if(currentLevelIndex < gameLevels.count) {
                currentLevel = gameLevels[currentLevelIndex]
                let newScene = setupGameLevel(currentLevel!)
                self.transitionScene(newScene)
            } else {
                // Past the last level - go to postgame
                setGameState(.PostGame, levelIndex:0)
                return
            }
            view.scene!.rootNode.hidden = false
            currentLevel!.startLevel()
            view.play(self)
            break
        case .PostGame:
            view.scene!.rootNode.hidden = true
            currentLevel!.stopLevel()
            view.stop(self)
            break
        case .LevelComplete:
            view.scene!.rootNode.hidden = true
            currentLevel!.stopLevel()
            view.stop(self)
            break
        case .LevelFailed:
            view.scene!.rootNode.hidden = true
            currentLevel!.stopLevel()
            view.stop(self)
            break
        case .Paused:
            view.scene!.rootNode.hidden = false
            currentLevel!.pauseLevel()
            view.pause(self)
            break
        }
        
        self.gameState = gameState;
        
    }

    private func initializeGameLevel(levelName:String) -> GameLevel {
        //print("My class is \(NSStringFromClass(self.dynamicType))")
        let lName = namespace + "." + levelName
        let aClass = NSClassFromString(lName) as! NSObject.Type
        let level:GameLevel = aClass.init() as! GameLevel
        
        return level
    }
    
    private func setupGameLevel(level:GameLevel) -> SCNScene {
        guard let view = scnView else {
            fatalError("Scene View is not set")
        }
        let scene:SCNScene = level.createLevel(view)
        view.scene = scene
        view.delegate = level
        view.scene!.physicsWorld.contactDelegate = level
        
        // Hide scene till game starts playing
        view.scene!.rootNode.hidden = true
        return scene
    }

    private func transitionScene(scene:SCNScene) {
        let sceneTransition = SKTransition.moveInWithDirection(.Right, duration: 1.5)
        guard let view = scnView else {
            fatalError("Scene View is not set")
        }
        view.presentScene(scene, withTransition: sceneTransition, incomingPointOfView:nil, completionHandler:nil)
    }
    
    #if os(OSX)
    func mouseDown(theEvent: NSEvent) {
        guard let level = currentLevel else {
            return
        }
        level.mouseDown(theEvent)
    }
    
    func mouseUp(theEvent: NSEvent) {
        guard let level = currentLevel else {
            return
        }
        level.mouseUp(theEvent)
    }
    
    func keyDown(theEvent: NSEvent) {
        guard let level = currentLevel else {
            return
        }
        level.keyDown(theEvent)
    }
    
    func keyUp(theEvent: NSEvent) {
        guard let level = currentLevel else {
            return
        }
        level.keyUp(theEvent)
    }

    #else
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let level = currentLevel else {
            return
        }
        level.touchesBegan(touches, withEvent:event)
    }
    
    func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let level = currentLevel else {
            return
        }
        level.touchesMoved(touches, withEvent:event)

    }
    
    func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let level = currentLevel else {
            return
        }
        level.touchesEnded(touches, withEvent:event)

    }

    #endif
}
