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

class Assets{
    var type = ""
    var name = ""
    var price = 0.0
    var yield = 0.0
    var volatility = ""
    var count = 0
    
    init(_ type:String, _ name:String, _ price:Double, _ yield:Double, _ volatility:String){
        self.type = type
        self.name = name
        self.price = price
        self.yield = yield
        self.volatility = volatility
    }
}


var bondA = Assets("Bond", "Government Bond", 10, 0.1, "Low")
var bondB = Assets("Bond", "Tech Giant Bond", 1000, 125, "Medium")

var listOfAssets = [bondA , bondB]




class GameViewController: UIViewController {

    
    
    
    
    @IBOutlet weak var dateLabel: UILabel!
    var currentDay = 1
    var currentMonth = 1
    var currentYear = 2019
    
    
    
    @IBOutlet weak var displayedTotalValue: UILabel!
    var totalValue = 0.0
    
    @IBOutlet weak var displayedCash: UILabel!
    var currentCash = 0.0
    
    @IBOutlet weak var displayedBondA: UILabel!
    @IBOutlet weak var bondAOutlet: UIButton!

    
    @IBOutlet weak var displayedBondB: UILabel!
    @IBOutlet weak var bondBOutlet: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        if(timerStarted == false){
            timerStarted = true
            gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        }
               
        
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
    var buyMode = true
    
    func updatePrice(currentPrice: Double, volatility: String) -> Double{
        var percentChange = 0
        if(volatility == "High"){
            percentChange = (Int.random(in: -1925...2000))
        }
        else if(volatility == "Medium"){
            percentChange = (Int.random(in: -950...1000))
        }
        else{
            percentChange = (Int.random(in: -175...200))
        }
        
        var floatPercentChange = Double(percentChange)
        floatPercentChange = floatPercentChange/10000
        //print(floatPercentChange)
        let newPrice = currentPrice * (1 + floatPercentChange)
        return newPrice
    }
    
    func getDate(runningTime: Int) -> (Int, Int , Int){
        var days = runningTime
        var year = (days/365)
        year = year + 2019
        days = days % 365
        var month = -1
        var day = -1
        if (days <= 31){
            month = 1
            day = days
        }
        else if(days <= 59){
            month = 2
            day = days - 31
        }
        else if(days <= 90){
            month = 3
            day = days - 59
        }
        else if(days <= 120){
            month = 4
            day = days - 90
        }
        else if(days <= 151){
            month = 5
            day = days - 120
        }
        else if(days <= 181){
            month = 6
            day = days - 151
        }
        else if(days <= 212){
            month = 7
            day = days - 181
        }
        else if(days <= 243){
            month = 8
            day = days - 212
        }
        else if(days <= 273){
            month = 9
            day = days - 243
            
        }
        else if(days <= 304){
            month = 10
            day = days - 273
        }
        else if(days <= 334){
            month = 11
            day = days - 304
        }
        else{
            month = 12
            day = days - 334
        }
        /*
        print("Year: ", year)
        print("Month: ", month)
        print("Day: ", day)
        */
        if day == 0{
            day = 1
        }
        
        return (day, month, year)
    }
    
    @IBAction func buySellToggle(_ sender: Any) {
        if(buyMode == true){
            buyMode = false
        }
        else{
            buyMode = true
        }
        
        //print(buyMode)
    }
    
    
    @IBAction func getCashTapped(_ sender: Any) {
        currentCash += 1
        displayedCash.text = String("$\(currentCash)")
        
    }
    
    @objc fileprivate func fireTimer(){
        print("current cash is", currentCash)
        print("total value is", totalValue)
        //print("Timer fired!!!!")
        //print(runningTime)
        runningTime += 1
        totalValue = (round(totalValue * 100))/100
        bondA.price = (round(bondA.price * 100))/100
        bondB.price = (round(bondB.price * 100))/100
        currentCash = (round(currentCash * 100))/100
        displayedCash.text = String("$\(currentCash)")
        displayedBondA.text = String(bondA.count)
        displayedBondB.text = String(bondB.count)
        displayedTotalValue.text = String("$\(totalValue)")
        (currentDay, currentMonth, currentYear) = getDate(runningTime: runningTime)
        dateLabel.text = String("Date: \(currentMonth)/\(currentDay)/\(currentYear)")
        
        
        if(buyMode == true){
            bondAOutlet.setTitle("Buy Bond A - $\(bondA.price)", for: .normal)
            bondBOutlet.setTitle("Buy Bond B - $\(bondB.price)", for: .normal)
        }
        else{
            bondAOutlet.setTitle("Sell Bond A -  $\(bondA.price)", for: .normal)
            bondBOutlet.setTitle("Sell Bond B - $ \(bondB.price)", for: .normal)
        }
        
        
        
        if(currentDay == 1){// get paid at the first of the month
            for asset in listOfAssets{
                currentCash += (asset.yield * Double(asset.count))
                print("Interest paid from", asset.name, asset.yield)
            }
           displayedCash.text = String("$\(currentCash)")
           }
            bondA.price = updatePrice(currentPrice: bondA.price, volatility: bondA.volatility)
            bondB.price = updatePrice(currentPrice: bondB.price, volatility: bondB.volatility)
        var assetTotal = 0.0
        for asset in listOfAssets{
            assetTotal += (asset.price * Double(asset.count))
            
        }
        print("Asset total is: ", assetTotal)
        totalValue = currentCash + assetTotal
        
       }
    
    

    @IBAction func bondATapped(_ sender: Any) {
        if(buyMode == true){
            if(currentCash >= bondA.price){
                bondA.count += 1
                currentCash -= bondA.price
                   }
        }
        else{
            if(bondA.count > 0){
                bondA.count -= 1
                currentCash += bondA.price
            }
        }
       
        
    }
    
    @IBAction func bondBTapped(_ sender: Any) {
        if(buyMode == true){
            if(currentCash >= bondB.price){
                bondB.count += 1
                currentCash -= bondB.price
            }
        }
        else{
            if(bondB.count > 0){
                bondB.count -= 1
                currentCash += bondB.price
               }
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
