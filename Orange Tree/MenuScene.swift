//
//  MenuScene.swift
//  Orange Tree
//
//  Created by Lucia Reynoso on 9/23/18.
//  Copyright © 2018 Lucia Reynoso. All rights reserved.
//

import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    override func didMove(to view: SKView) {
        // did move
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            if let scene = GameScene(fileNamed: "Level-1") {
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
