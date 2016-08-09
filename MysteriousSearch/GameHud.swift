//
//  GameHud.swift
//  MysteriousSearch
//
//  Created by Sujan Vaidya on 8/9/16.
//  Copyright © 2016 Sujan Vaidya. All rights reserved.
//

import Foundation
import SpriteKit

public enum GameStateType {
    case Playing
    case TapToPlay
    case GameOver
}

public enum deviceHeight : CGFloat {
    case ExtraSmall = 320
    case Small = 375
    case Medium = 414
    case Large = 768
    case ExtraLarge = 1024
}

class GameHud {
    
    var gameStateLabelNode = SKLabelNode()
    var gamePointTextLabelNode = SKLabelNode()
    var gamePointCountLabelNode = SKLabelNode()
    var gameLifeTextLabelNode = SKLabelNode()
    var gameLifeCountLabelNode = SKLabelNode()
    var gamePointLabelNode = SKLabelNode()
    var skScene = SKScene()
    var scoreCount: Int
    var lifeCount: Int
    var state = GameStateType.TapToPlay
    var width: CGFloat
    var height: CGFloat

    init(sceneWidth: CGFloat, sceneHeight: CGFloat) {
        width = sceneWidth
        height = sceneHeight
        var posX: CGFloat = width / 2
        var posY: CGFloat = 0
        switch height {
            case deviceHeight.ExtraSmall.rawValue:
                posY = self.height / CGFloat(7)
            case deviceHeight.Small.rawValue:
                posY = self.height / CGFloat(7)
            case deviceHeight.Medium.rawValue:
                posY = self.height / CGFloat(8)
            case deviceHeight.Large.rawValue:
                posY = self.height / CGFloat(16)
            case deviceHeight.ExtraLarge.rawValue:
                posY = self.height / CGFloat(22)
            default:
            break
        }
        scoreCount = 0
        lifeCount = 3
        skScene = SKScene(size: CGSize(width: sceneWidth, height: 100))
        skScene.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        gameStateLabelNode = SKLabelNode(fontNamed: "Verdana-Bold ")
        gameStateLabelNode.fontSize = 36
        gameStateLabelNode.position.y = posY
        gameStateLabelNode.position.x = posX
        skScene.addChild(gameStateLabelNode)
    }
    
    func setupLabel() {
        let posX: CGFloat = width / 8
        var posY: CGFloat = 0
        switch height {
        case deviceHeight.ExtraSmall.rawValue:
            posY = self.height / CGFloat(4)
        case deviceHeight.Small.rawValue:
            posY = self.height / CGFloat(4.5)
        case deviceHeight.Medium.rawValue:
            posY = self.height / CGFloat(4.5)
        case deviceHeight.Large.rawValue:
            posY = self.height / CGFloat(9)
        case deviceHeight.ExtraLarge.rawValue:
            posY = self.height / CGFloat(13)
        default:
            break
        }
        
        gamePointTextLabelNode = SKLabelNode(fontNamed: "Verdana-Bold")
        gamePointTextLabelNode.fontSize = 8
        gamePointTextLabelNode.text = "Points"
        gamePointTextLabelNode.position = CGPoint(x: posX, y: posY)
        gamePointLabelNode.addChild(gamePointTextLabelNode)
        
        gamePointCountLabelNode = SKLabelNode(fontNamed: "Verdana-Bold")
        gamePointCountLabelNode.fontSize = 8
        gamePointCountLabelNode.position = CGPoint(x: 2 * posX, y: posY)
        gamePointLabelNode.addChild(gamePointCountLabelNode)
        
        gameLifeTextLabelNode = SKLabelNode(fontNamed: "Verdana-Bold")
        gameLifeTextLabelNode.fontSize = 8
        gameLifeTextLabelNode.text = "Life"
        gameLifeTextLabelNode.position = CGPoint(x: 6 * posX, y: posY)
        gamePointLabelNode.addChild(gameLifeTextLabelNode)
        
        gameLifeCountLabelNode = SKLabelNode(fontNamed: "Verdana-Bold")
        gameLifeCountLabelNode.fontSize = 8
        gameLifeCountLabelNode.position = CGPoint(x: 7 * posX, y: posY)
        gamePointLabelNode.addChild(gameLifeCountLabelNode)
        
        skScene.addChild(gamePointLabelNode)
    }
    
    func updateScore() {
        let scoreFormatted = String(format: "%0\(4)d", scoreCount)
        gamePointCountLabelNode.text = "\(scoreFormatted)"
    }
    
    func updateLife() {
        let scoreFormatted = String(format: "%0\(4)d", lifeCount)
        gameLifeCountLabelNode.text = "\(scoreFormatted)"
    }
    
    func updateGameStat() {
        gameStateLabelNode.text = "-Tap to play-"
    }
   
    func reset() {
        scoreCount = 0
        lifeCount = 3
        updateScore()
        updateLife()
    }
    
}
