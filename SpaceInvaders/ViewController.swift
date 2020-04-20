//
//  ViewController.swift
//  SpaceInvaders
//
//  Created by Timur Samigulin on 19.04.2020.
//  Copyright © 2020 Timur Samigulin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var txtGameOver: UILabel!
    @IBOutlet weak var player: UIImageView!
    @IBOutlet weak var txtHighScore: UILabel!
    @IBOutlet weak var highScore: UILabel!
    @IBOutlet weak var btnStartGame: UIButton!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!

    private var alians = [[Alian]]()
    private let game = Game()
    private var moveX: CGFloat = -1
    private var moveY: CGFloat = 0
    
    private var cdShoot = 20
    private var cdAlienShoot = 0
    
    private var alive = 20
    
    var bullets = [UIImageView]()
    var alienBullets = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if game.isDie {
            game.score = 0
            game.level = 1
        }
        score.text = String(game.score)
        level.text = String(game.level)
    }
    
    func beginGame() {
        txtGameOver.isHidden = true
        txtHighScore.isHidden = true
        highScore.isHidden = true
        btnStartGame.isHidden = true
        btnRight.isHidden = false
        btnLeft.isHidden = false
        
        if game.isDie {
            game.score = 0
            game.level = 1
        }
        score.text = String(game.score)
        level.text = String(game.level)
                
        game.isDie = false
        game.saveDie()
        alive = 20
        moveY = 0
        moveX = -1
        
        for (number, _) in bullets.enumerated() {
            bullets[number].removeFromSuperview()
        }
        
        for (number, _) in alienBullets.enumerated() {
            alienBullets[number].removeFromSuperview()
        }
        
        bullets.removeAll()
        alienBullets.removeAll()
        
        drawAlian()
    }
    
    func drawAlian() {
        let playerCGRect = CGRect(x: view.frame.width * 0.4 ,
                                  y: (10/11) * view.frame.height,
                                  width: (1/11) * view.frame.width ,
                                  height: (1/11) * view.frame.width)
        player.frame = playerCGRect
        if alians.count == 0 {
            for i in 1...5 {
                var aliansX = [Alian]()
                for j in 1...4{
                    let alianCGRect = CGRect(x: view.frame.width * CGFloat(i*2-1) * (1/11),
                                             y: view.frame.width * (1.5/11) * CGFloat(j),
                                             width: view.frame.width * (1/11),
                                             height: view.frame.width * (1/11))
                    let newAlian = Alian(frame: alianCGRect)
                    newAlian.image = #imageLiteral(resourceName: "Alien")
                    view.addSubview(newAlian)
                    aliansX.append(newAlian)
                }
                alians.append(aliansX)
            }
        } else {
            for i in 0...4 {
                for j in 0...3 {
                    alians[i][j].isHidden = false
                    let alienCGRect = CGRect(x: view.frame.width * CGFloat((i+1)*2-1) * (1/11),
                                             y: view.frame.width * (1.5/11) * CGFloat(j+1),
                                             width: view.frame.width * (1/11),
                                             height: view.frame.width * (1/11))
                    alians[i][j].frame = alienCGRect
                }
            }
        }
        startTimer()
    }

    @objc func startTimer() {
        let beginTime = mach_absolute_time()
        
        if !game.isDie {
            render()
            let endTime = mach_absolute_time()
            let kOneMillion: UInt64 = 100000 * 10000
            let time = Double(beginTime/kOneMillion) + Double(1.0/60.0) - Double(endTime/kOneMillion)
            if (time > 0) {
                perform(#selector(startTimer), with: nil, afterDelay: time)
            } else {
                startTimer()
            }
        }
    }
    
    @IBAction func onClickBtnBeginGame(_ sender: Any) {
        beginGame()
    }
    
    func shoot() {
        cdShoot += 1
        
        if cdShoot >= 20 {
            let playerFrame = CGRect(x: player.frame.origin.x + player.frame.width * 0.45,
                                y: player.frame.origin.y-player.frame.height * 0.3,
                                width: player.frame.width * 0.1,
                                height: player.frame.height * 0.5)
            let newBullet = UIImageView(frame: playerFrame)
            newBullet.image = #imageLiteral(resourceName: "bullet")
            view.addSubview(newBullet)
            bullets.append(newBullet)
            cdShoot = 0
        }
    }
    
    func alienShoot() {
        cdAlienShoot += 1
        
        if cdAlienShoot >= 100 {
            let x = Int.random(in: 0...4)
            let y = Int.random(in: 0...3)
            if alians[x][y].isHidden==false {
                let alienFrame = CGRect(x: alians[x][y].frame.origin.x + alians[x][y].frame.width * 0.45,
                                    y: alians[x][y].frame.origin.y + alians[x][y].frame.height * 0.3,
                                    width: alians[x][y].frame.width * 0.5,
                                    height: alians[x][y].frame.height * 0.5)
                let newAlienBullet = UIImageView(frame: alienFrame)
                newAlienBullet.image = #imageLiteral(resourceName: "bullet")
                view.addSubview(newAlienBullet)
                alienBullets.append(newAlienBullet)
                cdAlienShoot = 0
            }
        }
    }
    
    @IBAction func onClickLeft(_ sender: Any) {
        if(player.center.x > 50 && btnLeft.isHighlighted){
            player.center = CGPoint(x:player.center.x - 10, y:player.center.y)
            perform(#selector(onClickLeft), with: nil, afterDelay: 0.05)
        }
    }
    
    
    @IBAction func onClickRight(_ sender: Any) {
        if(player.center.x < UIScreen.main.bounds.width - 50 && btnRight.isHighlighted){
            player.center = CGPoint(x:player.center.x + 10, y:player.center.y)
            perform(#selector(onClickRight), with: nil, afterDelay: 0.05)
        }
    }
    
    func killAlien() {
        let position = alians[0][3].frame.origin.y + alians[0][3].frame.height
        first: for (number, item) in bullets.enumerated(){
            item.frame.origin.y -= 10
            if item.frame.origin.y < -50 {
                bullets[number].removeFromSuperview()
                bullets.remove(at: number)
            } else {
                if position >= item.frame.origin.y {
                    second : for i in 0...4 {
                        for j in 0...3 {
                            if (item.frame.intersects(alians[i][j].frame) && alians[i][j].isHidden==false) {
                                bullets[number].removeFromSuperview()
                                bullets.remove(at: number)
                                alians[i][j].isHidden = true
                                game.updateScore()
                                score.text = String(game.score)
                                alive -= 1
                            
                                if alive == 0 {
                                    alive = 20
                                    game.isDie = false
                                    game.level += 1
                                    game.saveLevel()
                                    game.saveScore()
                                    beginGame()
                                    break first
                                }
                                break second
                            }
                        }
                    }
                }
            }
        }
    }
    
    func render() {
        shoot()
        alienShoot()
        move()
        killAlien()
    }
    
    func move() {
        for i in 0...4 {
            for j in 0...3 {
                alians[i][j].frame.origin.x += moveX
            }
        }
        
        for i in 0...4{
            if alians[i][0].frame.origin.x + alians[i][0].frame.width >= view.frame.width {
                moveX = -1
                moveY = view.frame.width * (1/44)
            }
            if alians[i][0].frame.origin.x  <= 0 {
                moveX = 1
                moveY = view.frame.width * (1/44)
            }
        }
        
        for i in 0...4 {
            for j in 0...3 {
                alians[i][j].frame.origin.y += moveY
            }
        }
        
        moveY = 0
        
        for (number, item) in alienBullets.enumerated() {
            item.frame.origin.y += 5
            if item.frame.origin.y > item.frame.height + view.frame.height {
                alienBullets[number].removeFromSuperview()
                alienBullets.remove(at: number)
            }
            
            if item.frame.origin.y - player.frame.height * 0.3 > player.frame.origin.y{
                if (item.frame.intersects(player.frame)) {
                    gameOver()
                }
            }
        }
        
        if alians[0][3].frame.origin.y + alians[0][3].frame.height > player.frame.origin.y {
            first: for i in 0...4 {
                for j in 0...3 {
                    if (alians[i][j].frame.origin.y + alians[i][j].frame.height > player.frame.origin.y) && (alians[i][j].isHidden == false){
                        gameOver()
                        break first
                    }
                }
            }
        }
    }
    
    func gameOver() {
        game.checkHighScore()
        highScore.text = String(game.highScore)
        highScore.isHidden = false
        txtHighScore.isHidden = false
        txtGameOver.isHidden = false
        btnStartGame.isHidden = false
        btnRight.isHidden = true
        btnLeft.isHidden = true
        game.isDie = true
        game.saveDie()
    }
}

