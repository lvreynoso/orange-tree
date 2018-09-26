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
    
    let anima: SKSpriteNode
    enum Phase {
        case fadeIn, pause, fadeOut
    }
    var phase: Phase?
    
    init(visual: SKSpriteNode, size: CGSize) {
        self.anima = visual
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        // paint it black
        self.backgroundColor = .black
        
        // place the logo
        // let logoTexture = SKTexture(imageNamed: "logo.png")
        // anima = SKSpriteNode(texture: logoTexture)
        anima.anchorPoint = CGPoint(x: 0, y: 0)
        anima.position = CGPoint(x: 0, y: 0)
        anima.alpha = 0
        
        // scale the logo properly
        let screenSize = self.size
        let animaSize = anima.calculateAccumulatedFrame() // ?? CGRect(x: 0, y: 0, width: 2048, height: 1334)
        let xScale = screenSize.width / animaSize.width
        let yScale = screenSize.height / animaSize.height
        if xScale >= yScale {
            anima.setScale(xScale)
        } else {
            anima.setScale(yScale)
        }
        
        // display logo
        addChild(anima)
        /*
        if let logo = anima {
            addChild(logo)
        }
        */
        
        // set the fade in
        phase = .fadeIn
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let currentPhase = phase /*, let _ = anima?.alpha */ {
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
