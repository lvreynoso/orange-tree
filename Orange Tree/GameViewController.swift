//
//  GameViewController.swift
//  Orange Tree
//
//  Created by Lucia Reynoso on 9/14/18.
//  Copyright © 2018 Lucia Reynoso. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // preload our splash image
            let visual = SKSpriteNode(fileNamed: "logo.png") ?? SKSpriteNode(fileNamed: "OrangeTree.png") ?? SKSpriteNode(texture: nil, color: .blue, size: CGSize(width: 2048, height: 1334))
            let size = view.frame.size
            // Load the SKScene from 'Menu.sks'
            let scene = SplashScene(visual: visual, size: size)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
