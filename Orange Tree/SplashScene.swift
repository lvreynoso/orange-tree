//
//  SplashScene.swift
//  Orange Tree
//
//  Created by Lucia Reynoso on 9/24/18.
//  Copyright © 2018 Lucia Reynoso. All rights reserved.
//

import SpriteKit
import GameplayKit

class SplashScene: SKScene {
    
    override func didMove(to view: SKView) {
        // paint it black
        self.backgroundColor = .black
        
        // load our logo image
        let texture = SKTexture(imageNamed: "logo")
        let logo = SKSpriteNode(texture: texture, color: .clear, size: self.size)
        logo.alpha = 0
        
        // display it on screen
        addChild(logo)
        
        // fade animation code
        let fadeSequence = SKAction.sequence([SKAction.wait(forDuration: 0.2), SKAction.fadeIn(withDuration: 1), SKAction.wait(forDuration: 1), SKAction.fadeOut(withDuration: 1)])
        logo.run(fadeSequence) {
            // after we're done fading, load the menu screen
            if let view = self.view {
                // Load the SKScene from 'Menu.sks'
                if let scene = MenuScene(fileNamed: "Menu") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    // Present the scene
                    view.presentScene(scene)
                    view.ignoresSiblingOrder = true
                    view.showsFPS = false
                    view.showsNodeCount = false
                }
            }
        }
    }
    
 }
