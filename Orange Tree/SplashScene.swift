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
    
    var anima = SKSpriteNode(imageNamed: "logo")
    enum Phase {
        case fadeIn, pause, fadeOut
    }
    var phase: Phase?
    
    override func didMove(to view: SKView) {
        // place the logo
        anima.position = CGPoint(x: 0, y: 0)
        anima.alpha = 0
        
        // scale the logo properly
        let screenSize = self.size
        let animaSize = anima.calculateAccumulatedFrame()
        let xScale = screenSize.width / animaSize.width
        let yScale = screenSize.height / animaSize.height
        if xScale >= yScale {
            anima.setScale(xScale)
        } else {
            anima.setScale(yScale)
        }
        
        // set the fade in
        phase = .fadeIn
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let currentPhase = phase {
            switch currentPhase {
            case .fadeIn:
                anima.alpha += 0.0167
                if anima.alpha >= CGFloat(1) {
                    phase = .pause
                }
            case .pause:
                Thread.sleep(forTimeInterval: 1)
                phase = .fadeOut
            case .fadeOut:
                anima.alpha -= 0.0167
                if anima.alpha <= CGFloat(0) {
                    loadMenu()
                }
            }
        }
    }
    
    func loadMenu() {
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
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
