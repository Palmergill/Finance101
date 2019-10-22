//
//  GameViewController.swift
//  Finance101
//
//  Created by Palmer Gill on 10/20/19.
//  Copyright © 2019 Palmer Gill. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    
    @IBOutlet weak var displayedCash: UILabel!
    var currentCash = 0
    
    @IBOutlet weak var displayedBondA: UILabel!
    var currentBondA = 0
    
    @IBOutlet weak var displayedBondB: UILabel!
    var currentBondB = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }
    
    var timerStarted = false
    var gameTimer = Timer()
    var runningTime = 0
    
    @IBAction func getCashTapped(_ sender: Any) {
        currentCash += 1
        displayedCash.text = String("$\(currentCash)")
        if(timerStarted == false){
                   timerStarted = true
                   gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
               }
                      
    }
    
    @objc fileprivate func fireTimer(){
        //print("Timer fired!!!!")
        //print(runningTime)
        runningTime += 1
        
        if(runningTime % 100 == 0){
            currentCash += currentBondA //1 dollar per A bond
            currentCash += currentBondB * 125 //125 dollars per bond
           displayedCash.text = String("$\(currentCash)")
           }
       }
    

    @IBAction func buyBondATapped(_ sender: Any) {
        if(currentCash >= 10){
                          currentBondA += 1
                          currentCash -= 10
                          displayedCash.text = String("$\(currentCash)")
                          displayedBondA.text = String(currentBondA)
                      }
    }
    
    
    
    @IBAction func buyBondBTapped(_ sender: Any) {
        if(currentCash >= 1000){
            currentBondB += 1
            currentCash -= 1000
            displayedCash.text = String("$\(currentCash)")
            displayedBondB.text = String(currentBondB)
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

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
