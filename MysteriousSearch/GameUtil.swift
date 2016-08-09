//
//  GameUtil.swift
//  MysteriousSearch
//
//  Created by Sujan Vaidya on 8/9/16.
//  Copyright © 2016 Sujan Vaidya. All rights reserved.
//

import UIKit
import SceneKit

struct CollisionCategory {
    
    static let Character = 1
    static let Wall = 4
    static let Box = 8
    static let Coin = 16
    static let Shield = 32
    static let Sword = 64
    static let Fire = 128
}

var sounds:[String:SCNAudioSource] = [: ]

func addRotation() -> CABasicAnimation {
    let spin = CABasicAnimation(keyPath: "rotation")
    spin.fromValue = NSValue(SCNVector4: SCNVector4(x: 0, y: 0, z: 1, w: 0))
    spin.toValue = NSValue(SCNVector4: SCNVector4(x: 0, y: 0, z: 1, w: Float(2 * M_PI)))
    spin.duration = 3
    spin.repeatCount = .infinity
    return spin
}

func importDae(mysteryIndex: Int) -> SCNNode {
    var daeScene = SCNScene()
    let node = SCNNode()
    node.physicsBody = SCNPhysicsBody(
        type: .Static,
        shape: SCNPhysicsShape(
            geometry: SCNBox(
                width: 1,
                height: 1,
                length: 1,
                chamferRadius: 0
            ),
            options: nil)
    )
    switch mysteryIndex {
    case 0:
        daeScene = SCNScene(named: "art.scnassets/Amazonian_Sword.dae")!
        node.addChildNode(
            daeScene.rootNode.childNodeWithName(
                "Armature",
                recursively: true
                )!
        )
        node.addChildNode(
            daeScene.rootNode.childNodeWithName(
                "Amazonian_Sword",
                recursively: true)!
        )
        node.position = SCNVector3(x: -14, y: 2.5, z: -50)
        node.physicsBody?.categoryBitMask = CollisionCategory.Sword
    case 1:
        daeScene = SCNScene(named: "art.scnassets/Amazonian_Shield.dae")!
        node.addChildNode(
            daeScene.rootNode.childNodeWithName(
                "Armature",
                recursively: true)!
        )
        node.addChildNode(
            daeScene.rootNode.childNodeWithName(
                "AmazonianShield",
                recursively: true)!
        )
        node.position = SCNVector3(x: 35, y: 2.5, z: 0)
        node.physicsBody?.categoryBitMask = CollisionCategory.Shield
    default:
        break
    }
    return node
}

func computeDistance(point1: SCNVector3, point2: SCNVector3) -> Float {
    var distance: Float = 10.0
    let xd = point2.x - point1.x
    let yd = point2.y - point1.y
    let zd = point2.z - point1.z
    distance = sqrt(xd * xd + yd * yd + zd * zd)
    return distance
}

func loadSound(name: String, fileNamed: String) {
    let sound = SCNAudioSource(fileNamed: fileNamed)!
    sound.load()
    sounds[name] = sound
}

func playSound(node: SCNNode, name: String) {
    let sound = sounds[name]
    node.runAction(SCNAction.playAudioSource(sound!, waitForCompletion: true))
}


