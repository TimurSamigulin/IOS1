//
//  Game.swift
//  SpaceInvaders
//
//  Created by Денис Турыгин on 20.04.2020.
//  Copyright © 2020 Timur Samigulin. All rights reserved.
//

import Foundation


class Game {
    var score: Int = 0
    var level: Int = 1
    var isDie: Bool = true
    var highScore: Int = 0
    
    private let defaults = UserDefaults.standard
    
    init() {
        self.score = defaults.integer(forKey: "score")
        self.level = defaults.integer(forKey: "level")
        self.isDie = defaults.bool(forKey: "die")
        self.highScore = defaults.integer(forKey: "highScore")
    }
    
    func saveScore() {
        defaults.set(score, forKey: "score")
    }
    
    func saveLevel() {
        defaults.set(level, forKey: "level")
    }
    
    func saveDie() {
        defaults.set(isDie, forKey: "die")
    }
    
    func saveHighScore() {
        defaults.set(highScore, forKey: "highScore")
    }
    
    func checkHighScore() {
        if highScore < score {
            highScore = score
            saveHighScore()
        }
    }
    
    func updateScore() {
        score += level
    }
}
