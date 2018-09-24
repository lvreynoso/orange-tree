//
//  GameScene.swift
//  Orange Tree
//
//  Created by Lucia Reynoso on 9/14/18.
//  Copyright © 2018 Lucia Reynoso. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var orangeTree: SKSpriteNode!
    var orange: Orange?
    var touchStart: CGPoint = .zero
    var shapeNode = SKShapeNode()
    var boundary = SKNode()
    var numOfLevels: Int = 2
    enum GameState {
        case run, pause, gameOver, win
    }
    var state: GameState = .pause
    var orangeSupply: Int = 7
    enum OrangeState {
        case none, ready, fire
    }
    var orangeState: OrangeState = .none
    let orangesLabel = SKLabelNode(fontNamed: "Helvetica")
    
    // class method to load sks files
    static func Load(level: Int) -> GameScene? {
        return GameScene(fileNamed: "Level-\(level)")
    }
    
    override func didMove(to view: SKView) {
        // connect game objects
        orangeTree = childNode(withName: "tree") as? SKSpriteNode
        
        // configure shapeNode
        shapeNode.lineWidth = 20
        shapeNode.lineCap = .round
        shapeNode.strokeColor = UIColor(white: 1, alpha: 0.3)
        addChild(shapeNode)
        
        physicsWorld.contactDelegate = self
        
        // setup boundaries
        boundary.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: .zero, size: size))
        boundary.position = .zero
        addChild(boundary)
        
        // add sun to the scene
        let sun = SKSpriteNode(imageNamed: "Sun")
        sun.name = "sun"
        sun.position.x = size.width - (sun.size.width * 0.75)
        sun.position.y = size.height - (sun.size.height * 0.75)
        addChild(sun)
        
        // add orange count to the scene
        orangesLabel.text = "Oranges: \(orangeSupply)"
        orangesLabel.position = CGPoint(x: 150, y: self.size.height - 100)
        orangesLabel.fontColor = .black
        orangesLabel.fontSize = 45
        orangesLabel.name = "score"
        
        addChild(orangesLabel)
        
        state = .run
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateLabel()
        var objectsAreMoving: Bool = false
        var skullsExist: Bool = false
        self.enumerateChildNodes(withName: "//*") {
            node, _ in
            if let name = node.name {
                if name == "skull" {
                    skullsExist = true
                }
            }
            if self.isMoving(node) {
                objectsAreMoving = true
            }
        }
        if skullsExist == false && state == .run {
            win()
            // return
        }
        if orangeSupply <= 0 && objectsAreMoving == false && state == .run {
            gameOver()
            // return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if state == .run {
            // Get the location of the touch on the touch screen
            let touch = touches.first!
            let location = touch.location(in: self)
            
            // check if the touch was on the orange tree
            if atPoint(location).name == "tree" && self.orangeSupply > 0 && orangeState == .none {
                // create the orange and add it to the scene at the touch location
                orange = Orange()
                orange?.name = "orange"
                orange?.physicsBody?.isDynamic = false
                orange?.position = location
                orangeState = .ready
                addChild(orange!)
                
                //store the location of the touch
                touchStart = location
            }
            
            for node in nodes(at: location) {
                if node.name == "sun" {
                    let n = Int.random(in: 1...numOfLevels)
                    if let scene = GameScene.Load(level: n) {
                        scene.scaleMode = .aspectFill
                        if let view = view {
                            view.presentScene(scene)
                        }
                    }
                }
            }
        } else if state == .gameOver {
            if let view = self.view {
                // Load the SKScene from 'GameScene.sks'
                if let scene = MenuScene(fileNamed: "Menu") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view.presentScene(scene)
                    resetVariables()
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = false
                    view.showsNodeCount = false
                }
            }
        } else if state == .win {
            let n = Int.random(in: 1...numOfLevels)
            if let scene = GameScene.Load(level: n) {
                scene.scaleMode = .aspectFill
                if let view = view {
                    view.presentScene(scene)
                    resetVariables()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get location of touch
        let touch = touches.first!
        let location = touch.location(in: self)
        
        // update the position of the orange to the current location
        if self.orangeState == .ready {
            var groundHeight: CGFloat = 0
            self.enumerateChildNodes(withName: "ground") {
                node, _ in
                let nodeRectangle = node.calculateAccumulatedFrame()
                groundHeight = nodeRectangle.height
            }
            if location.y > groundHeight {
                orange?.position = location
            } else {
                orange?.position.x = location.x
            }
            
            // draw the firing vector
            let path = UIBezierPath()
            path.move(to: touchStart)
            path.addLine(to: location)
            shapeNode.path = path.cgPath
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.orangeState == .ready {
            orangeState = .fire
            // get location where touch ended
            let touch = touches.first!
            let location = touch.location(in: self)
            
            let dx = (touchStart.x - location.x) * 0.5
            let dy = (touchStart.y - location.y) * 0.5
            let vector = CGVector(dx: dx, dy: dy)
            
            // set the orange dynamic again and apply the vector as an impulse
            orange?.physicsBody?.isDynamic = true
            orange?.physicsBody?.applyImpulse(vector)
            orangeSupply -= 1
            orangeState = .none
            
            // remove firing vector
            shapeNode.path = nil
        }
    }
    
    func updateLabel() {
        orangesLabel.text = "Oranges: \(orangeSupply)"
    }
    
    func gameOver() {
        state = .gameOver
        // paint it red
        let turnRed = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.50)
        scene?.enumerateChildNodes(withName: "//*") {
            node, _ in
            node.run(turnRed)
        }
        let gameOverLabel = SKLabelNode(fontNamed: "Helvetica")
        gameOverLabel.text = "Game Over!"
        gameOverLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        gameOverLabel.fontColor = .white
        gameOverLabel.fontSize = 45
        
        addChild(gameOverLabel)
    }
    
    func win() {
        state = .win
        
        let aWinnerIsYouLabel = SKLabelNode(fontNamed: "Helvetica")
        aWinnerIsYouLabel.text = "A Winner is You!"
        aWinnerIsYouLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        aWinnerIsYouLabel.fontColor = .white
        aWinnerIsYouLabel.fontSize = 45
        aWinnerIsYouLabel.name = "winner"
        
        addChild(aWinnerIsYouLabel)
    }
    
    func resetVariables() {
        self.touchStart = .zero
        self.state = .pause
        self.orangeSupply = 7
        self.orangeState = .none
    }
    
    func isMoving(_ node: SKNode) -> Bool {
        var moving: Bool = false
        if let v = node.physicsBody?.velocity {
            if (abs(v.dx) >= 15 || abs(v.dy) >= 15) && 0 < node.position.x && node.position.x < self.size.width && 0 < node.position.y && node.position.y < self.size.height {
                moving = true
            }
        }
        return moving
    }
}

extension GameScene: SKPhysicsContactDelegate {
    // called when physicsWorld detects two nodes colliding
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        // check that the bodies collided hard enough
        if contact.collisionImpulse > 15 {
            if nodeA?.name == "skull" {
                removeSkull(node: nodeA!)
            } else if nodeB?.name == "skull" {
                removeSkull(node: nodeB!)
            }
        }
    }
    
    func removeSkull(node: SKNode) {
        node.removeFromParent()
    }
}
