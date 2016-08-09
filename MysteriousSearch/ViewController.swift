//
//  ViewController.swift
//  MysteriousSearch
//
//  Created by Sujan Vaidya on 8/9/16.
//  Copyright © 2016 Sujan Vaidya. All rights reserved.
//

import UIKit
import SceneKit
import CoreMotion
import SpriteKit

class ViewController: UIViewController {

    var scnScene = SCNScene()
    var scnView = SCNView()
    
    var camera = SCNCamera()
    var cameraNode = SCNNode()
    
    var lightNode = SCNNode()
    
    var characterNode = SCNNode()
    
    var manager = CMMotionManager()
    
    var runDirection = 0
    var startRun = false
    
    var walkGesture: UIPanGestureRecognizer?
    
    var isGestureEnabled = false
    
    var characterEulerAngle = SCNVector3Zero
    
    var game: GameHud?
    var skOverlay = SKScene()
    
    var gameStart = true
    
    var particleType: SCNParticleSystem?
    var fireCubeNode = SCNNode()
    
    var fireCube = SCNGeometry()
    var fireCubeClone1 = SCNNode()
    var fireCubeClone2 = SCNNode()
    var fireCubeClone3 = SCNNode()
    
    var boxNode1 = SCNNode()
    var boxNode2 = SCNNode()
    var boxNode3 = SCNNode()
    
    var buttonForBox = SCNNode()
    var buttonForFire = SCNNode()
    var buttonClone1 = SCNNode()
    var buttonClone2 = SCNNode()
    var buttonClone3 = SCNNode()
    var buttonClone4 = SCNNode()
    var buttonClone5 = SCNNode()
    var buttonClone6 = SCNNode()
    var buttonClone7 = SCNNode()
    var buttonClone8 = SCNNode()
    var buttonClone9 = SCNNode()
    var buttonClone10 = SCNNode()
    var buttonClone11 = SCNNode()
    var buttonArray = [SCNNode]()
    
    var countForWalkSound = 0
    var countForLifeupdate = 0
    
    var hiddenMarvel = [SCNNode]()
    var hiddenBox = [SCNNode]()
    var hiddenFire = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(scnView)
        setupScene()
        setupCamera()
        setupLight()
        setupCharacter()
        setupSound()
        setupFire()
        setupButton()
        setupButtonForBox()
        setupButtonForFire()
        setupMarvel()
        setupGesture()
        setupRotation()
        scnView.scene = scnScene
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        scnView.frame = self.view.bounds
        scnView.backgroundColor = UIColor.blackColor()
        game = GameHud(sceneWidth: scnView.bounds.width, sceneHeight: scnView.bounds.height)
        skOverlay = game!.skScene
        scnView.overlaySKScene = skOverlay
        game?.updateGameStat()
    }
    
    func setupScene() {
        scnScene = SCNScene(named: "art.scnassets/Game.scn")!
        scnView.delegate = self
        scnScene.physicsWorld.contactDelegate = self
    }

    func setupCamera() {
        camera = SCNCamera()
        cameraNode.camera = camera
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func setupLight() {
        lightNode.light = SCNLight()
        lightNode.light?.type = SCNLightTypeSpot
        lightNode.light?.attenuationEndDistance = 60
        lightNode.light?.spotInnerAngle = 10
        lightNode.light?.spotOuterAngle = 50
        scnScene.rootNode.addChildNode(lightNode)
    }
    
    func setupCharacter() {
        characterNode.physicsBody = SCNPhysicsBody(
            type: .Dynamic,
            shape: SCNPhysicsShape(
                geometry: SCNBox(
                    width: 2,
                    height: 2,
                    length: 2,
                    chamferRadius: 0
                ),
            options: nil))
        characterNode.physicsBody?.angularDamping = 0.9999999
        characterNode.physicsBody?.damping = 0.9999999
        characterNode.physicsBody?.rollingFriction = 0
        characterNode.physicsBody?.friction = 0
        characterNode.physicsBody?.restitution = 0
        characterNode.physicsBody?.velocityFactor = SCNVector3(x: 1, y: 0, z: 1)
        characterNode.physicsBody?.categoryBitMask = CollisionCategory.Character
        characterNode.physicsBody?.contactTestBitMask = CollisionCategory.Wall |
            CollisionCategory.Coin |
            CollisionCategory.Shield |
            CollisionCategory.Sword |
            CollisionCategory.Box |
            CollisionCategory.Fire
        characterNode.position = SCNVector3(x: 0, y: 2.5, z: -5)
        characterNode.name = "hero"
        characterNode.addChildNode(cameraNode)
        characterNode.addChildNode(lightNode)
        scnScene.rootNode.addChildNode(characterNode)
    }
    
    func setupSound() {
        loadSound("GameStart", fileNamed: "MyResources/Sounds/GameStart.mp3")
        loadSound("BoxStrike", fileNamed: "MyResources/Sounds/BoxStrike.wav")
        loadSound("MarvelCollect", fileNamed: "MyResources/Sounds/MarvelCollect.mp3")
        loadSound("Scream", fileNamed: "MyResources/Sounds/Scream.wav")
        loadSound("Walk", fileNamed: "MyResources/Sounds/Walk.wav")
        loadSound("ButtonBox", fileNamed: "MyResources/Sounds/ButtonBox.wav")
        loadSound("ButtonFire", fileNamed: "MyResources/Sounds/ButtonFire.wav")
    }
    
    func setupFire() {
        let fireNodeLeft1 = SCNNode()
        fireNodeLeft1.position = firePosition[0]
        fireNodeLeft1.addParticleSystem(getParticleSystem(1))
        let fireNodeLeft2 = SCNNode()
        fireNodeLeft2.position = firePosition[1]
        fireNodeLeft2.addParticleSystem(getParticleSystem(1))
        let fireNodeLeft3 = SCNNode()
        fireNodeLeft3.position = firePosition[2]
        fireNodeLeft3.addParticleSystem(getParticleSystem(1))

        let fireNodeRight1 = SCNNode()
        fireNodeRight1.position = firePosition[3]
        fireNodeRight1.addParticleSystem(getParticleSystem(2))
        let fireNodeRight2 = SCNNode()
        fireNodeRight2.position = firePosition[4]
        fireNodeRight2.addParticleSystem(getParticleSystem(2))
        let fireNodeRight3 = SCNNode()
        fireNodeRight3.position = firePosition[5]
        fireNodeRight3.addParticleSystem(getParticleSystem(2))
        
        fireCube = SCNBox(width: 5, height: 5, length: 3, chamferRadius: 0)
        fireCube.firstMaterial?.transparency = 0
        fireCubeNode = SCNNode()
        fireCubeNode.physicsBody = SCNPhysicsBody(
            type: .Static,
            shape: SCNPhysicsShape(geometry: fireCube, options: nil)
        )
        fireCubeNode.physicsBody?.categoryBitMask = CollisionCategory.Fire
        fireCubeNode.addChildNode(fireNodeLeft1)
        fireCubeNode.addChildNode(fireNodeLeft2)
        fireCubeNode.addChildNode(fireNodeLeft3)
        fireCubeNode.addChildNode(fireNodeRight1)
        fireCubeNode.addChildNode(fireNodeRight2)
        fireCubeNode.addChildNode(fireNodeRight3)
        fireCubeClone1 = fireCubeNode.clone()
        fireCubeClone2 = fireCubeNode.clone()
        fireCubeClone3 = fireCubeNode.clone()
    }
    
    func setupButton() {
        let buttonGeometryForBox = SCNCylinder(radius: 0.3, height: 0.9)
        buttonGeometryForBox.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/Button_Box.png")
        buttonForBox = SCNNode(geometry: buttonGeometryForBox)
        
        let buttonGeometryForFire = SCNCylinder(radius: 0.2, height: 0.9)
        buttonGeometryForFire.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/Button_Fire.jpg")
        buttonForFire = SCNNode(geometry: buttonGeometryForFire)
    }
    
    func setupButtonForBox() {
        boxNode1 = scnScene.rootNode.childNodeWithName("box1", recursively: true)!
        boxNode2 = scnScene.rootNode.childNodeWithName("box2", recursively: true)!
        boxNode3 = scnScene.rootNode.childNodeWithName("box3", recursively: true)!
        
        //first box first button
        buttonClone1 = buttonForBox.clone()
        buttonClone1.position = SCNVector3(2, 0, 0)
        buttonClone1.eulerAngles.z = Float(M_PI_2)
        buttonClone1.name = "BoxPush"
        boxNode1.addChildNode(buttonClone1)
        //first box second button
        buttonClone2 = buttonForBox.clone()
        buttonClone2.position = SCNVector3(-2, 0, 0)
        buttonClone2.eulerAngles.z = Float(M_PI_2)
        buttonClone2.name = "BoxPush"
        boxNode1.addChildNode(buttonClone2)
        
        //second box first button
        buttonClone3 = buttonForBox.clone()
        buttonClone3.position = SCNVector3(-2, 0, 0)
        buttonClone3.eulerAngles.z = Float(M_PI_2)
        buttonClone3.name = "BoxPush"
        boxNode2.addChildNode(buttonClone3)
        //second box second button
        buttonClone4 = buttonForBox.clone()
        buttonClone4.position = SCNVector3(2, 0, 0)
        buttonClone4.eulerAngles.z = Float(M_PI_2)
        buttonClone4.name = "BoxPush"
        boxNode2.addChildNode(buttonClone4)
        //second box third button
        buttonClone5 = buttonForBox.clone()
        buttonClone5.position = SCNVector3(0, 0, -2)
        buttonClone5.eulerAngles.x = Float(M_PI_2)
        buttonClone5.name = "BoxPush"
        boxNode2.addChildNode(buttonClone5)
        
        //third box first button
        buttonClone6 = buttonForBox.clone()
        buttonClone6.position = SCNVector3(-2, 0, 0)
        buttonClone6.eulerAngles.z = Float(M_PI_2)
        buttonClone6.name = "BoxPush"
        boxNode3.addChildNode(buttonClone6)
        
        buttonArray.append(buttonClone1)
        buttonArray.append(buttonClone2)
        buttonArray.append(buttonClone3)
        buttonArray.append(buttonClone4)
        buttonArray.append(buttonClone5)
        buttonArray.append(buttonClone6)
    }
    
    func setupButtonForFire() {
        buttonForFire.addParticleSystem(SCNParticleSystem(named: "WaterFlow", inDirectory: nil)!)
        // first button for first fire
        buttonClone7 = buttonForFire.clone()
        buttonClone7.position = SCNVector3(-2.9, 1, 3)
        buttonClone7.eulerAngles.z = Float(M_PI_2)
        buttonClone7.name = "FireExtinguish"
        fireCubeClone1.addChildNode(buttonClone7)
        // second button for first fire
        buttonClone8 = buttonForFire.clone()
        buttonClone8.position = SCNVector3(2.9, 1, -3)
        buttonClone8.eulerAngles.z = Float(M_PI_2)
        buttonClone8.name = "FireExtinguish"
        fireCubeClone1.addChildNode(buttonClone8)
        
        // first button for second fire
        buttonClone9 = buttonForFire.clone()
        buttonClone9.position = SCNVector3(2.9, 1, -3)
        buttonClone9.eulerAngles.z = Float(M_PI_2)
        buttonClone9.name = "FireExtinguish"
        fireCubeClone2.addChildNode(buttonClone9)
        
        // first button for third fire
        buttonClone10 = buttonForFire.clone()
        buttonClone10.position = SCNVector3(-2.9, 1, 3)
        buttonClone10.eulerAngles.z = Float(M_PI_2)
        buttonClone10.name = "FireExtinguish"
        fireCubeClone3.addChildNode(buttonClone10)
        // second button for third fire
        buttonClone11 = buttonForFire.clone()
        buttonClone11.position = SCNVector3(2.9, 1, -3)
        buttonClone11.eulerAngles.z = Float(M_PI_2)
        buttonClone11.name = "FireExtinguish"
        fireCubeClone3.addChildNode(buttonClone11)
        
        buttonArray.append(buttonClone7)
        buttonArray.append(buttonClone8)
        buttonArray.append(buttonClone9)
        buttonArray.append(buttonClone10)
        buttonArray.append(buttonClone11)
        
    }
    
    func setupFireCube(index: Int) {
        switch index {
            case 0:
                fireCubeClone1.position = fireCubePosition[index]
                scnScene.rootNode.addChildNode(fireCubeClone1)
            case 1:
                fireCubeClone2.position = fireCubePosition[index]
                scnScene.rootNode.addChildNode(fireCubeClone2)
            case 2:
                fireCubeClone3.position = fireCubePosition[index]
                scnScene.rootNode.addChildNode(fireCubeClone3)
            default:
                break
        }
    }
    
    func removeFireCube(index: Int) {
        switch index {
        case 0:
            fireCubeClone1.removeFromParentNode()
        case 1:
            fireCubeClone2.removeFromParentNode()
        case 2:
            fireCubeClone3.removeFromParentNode()
        default:
            break
        }
    }
    
    func getParticleSystem(direction: Int) -> SCNParticleSystem {
        switch direction {
            case 1:
                particleType = SCNParticleSystem(named: "FireHorizontalLeft", inDirectory: nil)!
            case 2:
                particleType = SCNParticleSystem(named: "FireHorizontalRight", inDirectory: nil)!
            default:
                break
        }
        return particleType!
    }
    
    func setupMarvel() {
        var node = SCNNode()
        for i in 0..<2 {
            node = importDae(i)
            node.addAnimation(addRotation(), forKey: "spin around")
            scnScene.rootNode.addChildNode(node)
        }
    }
    
    func setupGesture() {
        walkGesture = UIPanGestureRecognizer(
            target: self,
            action: "walkGestureRecognized:"
        )
        scnView.addGestureRecognizer(walkGesture!)
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: "tapGestureRecognized:")
        scnView.addGestureRecognizer(tapGesture)
    }
    
    func setupRotation() {
        manager.deviceMotionUpdateInterval = 1.0 / 60.0
        if manager.deviceMotionAvailable {
            manager.startDeviceMotionUpdatesToQueue(
                NSOperationQueue.mainQueue(),
                withHandler: {
                    (devMotion, error) -> Void in
                        if self.isGestureEnabled == false || self.game!.state == GameStateType.Playing {
                            self.characterEulerAngle = SCNVector3(
                                -Float((self.manager.deviceMotion?.attitude.roll)!) - Float(M_PI_2),
                                Float((self.manager.deviceMotion?.attitude.yaw)!),
                                0
                            )
                            self.characterNode.eulerAngles = self.characterEulerAngle
                        }
                }
            )
        }
    }
    
    func walkGestureRecognized(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Began:
            isGestureEnabled = true
            
        case .Ended:
            isGestureEnabled = false
            gesture.setTranslation(
                CGPointZero,
                inView: self.scnView
            )
        
        case .Cancelled:
            isGestureEnabled = false
            gesture.setTranslation(
                CGPointZero,
                inView: self.scnView
            )
        default:
            break
        }
    }
    
    func tapGestureRecognized(gesture: UITapGestureRecognizer) {
        if game!.state == GameStateType.TapToPlay {
            playGame()
        } else if game!.state == GameStateType.Playing {
            if isGestureEnabled == false {
                let position = gesture.locationInView(scnView)
                let hitResults = scnView.hitTest(position, options: nil)
                if hitResults.count > 0 {
                    let resultNode = hitResults[0].node
                    for i in 0..<self.buttonArray.count {
                        if resultNode == buttonArray[i] {
                            if resultNode.name == "BoxPush" {
                                playSound(characterNode, name: "ButtonBox")
                                self.hiddenBox.append(resultNode.parentNode!)
                            } else if resultNode.name == "FireExtinguish" {
                                playSound(characterNode, name: "ButtonFire")
                                self.hiddenFire.append(resultNode.parentNode!)
                            }
                            resultNode.parentNode!.runAction(
                                SCNAction.fadeOutWithDuration(2.0)
                            )
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                Int64(2.0 * Double(NSEC_PER_SEC))
                                ),
                                dispatch_get_main_queue()
                                ) { () -> Void in
                                    resultNode.parentNode?.hidden = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    func playGame() {
        game!.gameStateLabelNode.text = ""
        game!.state = GameStateType.Playing
        playSound(characterNode, name: "GameStart")
        if gameStart == true {
            game?.setupLabel()
            game?.updateLife()
            game?.updateScore()
        }
        gameStart = false
    }
    
    func checkForGameOver() {
        game?.lifeCount -= 1
        game!.updateLife()
        restartGame()
    }
    
    func restartGame() {
        characterNode.position = SCNVector3(x:0, y:2.5, z:-5)
        if game?.lifeCount == 0 {
            game?.state = GameStateType.TapToPlay
            let transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
            scnView.presentScene(
                scnScene,
                withTransition: transition,
                incomingPointOfView: cameraNode,
                completionHandler: { () -> Void in
                }
            )
            for i in 0..<hiddenMarvel.count {
                hiddenMarvel[i].hidden = false
            }
            for i in 0..<hiddenBox.count {
                hiddenBox[i].hidden = false
            }
            for i in 0..<hiddenFire.count {
                hiddenFire[i].hidden = false
            }
            setupFire()
            setupButton()
            setupButtonForFire()
            setupButtonForBox()
            game?.reset()
            game?.updateGameStat()
        }
        scnView.playing = true
    }
    
    func updateMotionControl() {
        let translation = walkGesture!.translationInView(self.scnView)
        //create impulse vector for hero
        let angle = characterNode.presentationNode.rotation.w * characterNode.presentationNode.rotation.y
        var impulse = SCNVector3(
            x: max(-1, min(1, Float(translation.x) / 500)),
            y: 0,
            z: max(-1, min(1, Float(-translation.y) / 500)))
        impulse = SCNVector3(
            x: impulse.x * cos(angle) - impulse.z * sin(angle),
            y: 0,
            z: impulse.x * -sin(angle) - impulse.z * cos(angle)
        )
        characterNode.physicsBody?.applyForce(impulse, impulse: true)
        characterNode.position = SCNVector3(
            x: characterNode.presentationNode.position.x + impulse.x,
            y: characterNode.presentationNode.position.y + impulse.y,
            z: characterNode.presentationNode.position.z + impulse.z
        )
        if isGestureEnabled == true {
            self.countForWalkSound += 1
            if countForWalkSound % 15 == 0 {
                playSound(characterNode, name: "Walk")
            }
        }
    }
    
    func updateFireNodePosition() {
        let dist1 = computeDistance(characterNode.position, point2: fireCubePosition[0])
        let dist2 = computeDistance(characterNode.position, point2: fireCubePosition[1])
        let dist3 = computeDistance(characterNode.position, point2: fireCubePosition[2])
        if dist1 < 15 {
            setupFireCube(0)
        } else {
            removeFireCube(0)
        }
        if dist2 < 15 {
            setupFireCube(1)
        } else {
            removeFireCube(1)
        }
        if dist3 < 15 {
            setupFireCube(2)
        } else {
            removeFireCube(2)
        }
    }
    
}

extension ViewController: SCNSceneRendererDelegate {
    
    func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        if game!.state == GameStateType.Playing {
            updateMotionControl()
            updateFireNodePosition()
        }
    }
    
}

extension ViewController : SCNPhysicsContactDelegate {
    
    func physicsWorld(world: SCNPhysicsWorld, didBeginContact contact: SCNPhysicsContact) {
        var contactNode: SCNNode!
        if contact.nodeA.name == "hero" {
            contactNode = contact.nodeB
        } else {
            contactNode = contact.nodeA
        }
        if contactNode.physicsBody?.categoryBitMask == CollisionCategory.Coin {
            playSound(characterNode, name: "MarvelCollect")
            hiddenMarvel.append(contactNode)
            contactNode.hidden = true
            game!.scoreCount += 5
            game!.updateScore()
        }
        if contactNode.physicsBody?.categoryBitMask == CollisionCategory.Sword {
            playSound(characterNode, name: "MarvelCollect")
            hiddenMarvel.append(contactNode)
            contactNode.hidden = true
            game!.scoreCount += 25
            game!.updateScore()
        }
        if contactNode.physicsBody?.categoryBitMask == CollisionCategory.Box {
            playSound(characterNode, name: "BoxStrike")
        }
        if contactNode.physicsBody?.categoryBitMask == CollisionCategory.Wall {
            //            play a sound
        }
        if contactNode.physicsBody?.categoryBitMask == CollisionCategory.Shield {
            playSound(characterNode, name: "MarvelCollect")
            hiddenMarvel.append(contactNode)
            contactNode.hidden = true
            game!.scoreCount += 15
            game!.updateScore()
        }
        if contactNode.physicsBody?.categoryBitMask == CollisionCategory.Fire {
            playSound(characterNode, name: "Scream")
            checkForGameOver()
        }
    }
    
}
