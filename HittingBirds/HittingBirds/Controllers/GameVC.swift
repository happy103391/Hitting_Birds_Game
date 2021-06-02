

import UIKit
import AVFoundation

class GameVC: UIViewController {
    
    @IBOutlet var birdButton: [UIButton]!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
//    每種鳥都設一個array來儲存
    let blueArray = Array(repeating: Bird.bluebird, count: 6)
    let brownArray = Array(repeating: Bird.brownbird, count: 3)
    let blackArray = Array(repeating: Bird.blackbird, count: 1)
    var gameTime = 35
    
    var bluebirdNum = 0
    var brownbirdNum = 0
    var blackbirdNum = 0
    var totalScore = 0
    
    let player = AVPlayer()
    
//    每次開啟遊戲畫面時都重設
    let defaults = UserDefaults.standard
    
    
    @IBAction func StartButtonPressed(_ sender: UIButton) {
        gameStart()
        sender.isHidden = true
    }
    
    
    @IBAction func birdButtonPressed(_ sender: UIButton) {
        
        let birdHit = birdButton[sender.tag - 1]
        
        if birdHit.currentImage != nil {

            // Set the score of each bird
            switch birdHit.titleLabel?.text {
            case Bird.bluebird.name:
                totalScore += Bird.bluebird.score
                bluebirdNum += 1
            case Bird.brownbird.name:
                totalScore += Bird.brownbird.score
                brownbirdNum += 1
            default:
                totalScore += Bird.blackbird.score
                blackbirdNum += 1
            }
            
            scoreLabel.text = "\(totalScore)"
            
            // Let the image and title disappear after hit
            birdHit.setImage(nil, for: .normal)
            birdHit.setTitle(nil, for: .normal)
            
        }
        

    }
    
    
    
    
    // The actions when game starts
    func gameStart() {
        
        // Timer: game countdown
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.gameTime -= 1
            self.timerLabel.text = String(self.gameTime)
            if self.gameTime == 0 {
                timer.invalidate()
                self.showTimesUpAlert()
                self.player.pause()
            }
        }
        
        // 設定timer：顯示鳥，直到時間到為止
        Timer.scheduledTimer(withTimeInterval: Double.random(in: 0.5...1.5), repeats: true) { (timer) in
            self.showBird()
            if self.gameTime == 0 {
                timer.invalidate()
                
                // 若計時結束，所有鳥都會消失
                for i in 0..<self.birdButton.count {
                    self.birdButton[i].setImage(nil, for: .normal)
                    self.birdButton[i].isEnabled = false
                }

            }
            
        }
    }
    
    // 顯示鳥的圖片
    @objc func showBird(){
        
        //button: find all the empty button
        var emptyButtonArray = [UIButton]()
        for i in 1...birdButton.count {
            if birdButton[i - 1].currentImage == nil {
                emptyButtonArray.append(birdButton[i - 1])
            }
        }
        
        // 加總所有鳥的總分
        let totalArray = blueArray + brownArray + blackArray

        // 讓鳥的出現隻數是隨機的
        let numberToAdd = Int.random(in: 1...3)
        
        // 隨機出現三種不同種類的鳥（用按鈕表示）
        if emptyButtonArray.count > 6 {
            emptyButtonArray.shuffle()
            for i in 0..<numberToAdd {
                
                // 產生隨機的鳥
                let randomBird = totalArray.randomElement()
                
                // 秀出隨機鳥的圖片
                emptyButtonArray[i].setImage(UIImage(named: "\(randomBird?.name ?? "brown_bird")"), for: .normal)
                
                // title是為了用來辨識鳥類
                emptyButtonArray[i].setTitle(randomBird?.name ?? "brown_bird", for: .normal)

                // 每種鳥的出現時間
                var birdAppearTime: Float = 3.0
                switch randomBird {
                case Bird.brownbird:
                    birdAppearTime = Bird.brownbird.appearTime
                case Bird.blackbird:
                    birdAppearTime = Bird.blackbird.appearTime
                default:
                    birdAppearTime = Bird.bluebird.appearTime
                }
                
                // 對每種鳥的出現時間進行計時
                Timer.scheduledTimer(withTimeInterval: TimeInterval(birdAppearTime), repeats: false) { (timer) in
                    
                    // 讓鳥的圖片消失
                    emptyButtonArray[i].setImage(nil, for: .normal)
                    
                    // 讓鳥的title消失
                    emptyButtonArray[i].setTitle(nil, for: .normal)
                }
                
            }
            
        }
        
    }
    
    func showTimesUpAlert(){
        let alert = UIAlertController(title: "Times Up！", message: "Your socre is：  \(totalScore)", preferredStyle: .alert)
        let seeResultAction = UIAlertAction(title: "See the results", style: .default) { (alertAction) in
            
            self.storeLatestResult()
            self.storeRank()
            self.performSegue(withIdentifier: "gameToLeaderboardSG", sender: self)
        }
        
        alert.addAction(seeResultAction)
        present(alert, animated: true, completion: nil )
        
    }
    
    func storeLatestResult(){
        let resultArray = [bluebirdNum, brownbirdNum, blackbirdNum, totalScore]
        defaults.set(resultArray, forKey: "ResultArray")
    }
    
    func storeRank() {
        
        var temp: Int!
        var comparedScore = totalScore
        
        // 確認玩家是不是此裝置第一個玩家，還是已經有歷史紀錄了
        if defaults.array(forKey: "ScoreArray") != nil {
            
            var scoreArray =  defaults.array(forKey: "ScoreArray")as! [Int]
            
            for i in 0 ..< 5 {
                
                if comparedScore >= scoreArray[i] {
                    temp = scoreArray[i]
                    scoreArray[i] = comparedScore
                    comparedScore = temp
                }
            }
            defaults.set(scoreArray, forKey: "ScoreArray")
        
        } else {
            // 如果玩家是第一次玩的話，就建立一個新的array去儲存他接下來每次的遊戲分數（前五高分的）
            let scoreArray = [comparedScore, 0, 0, 0, 0]
            defaults.set(scoreArray, forKey: "ScoreArray")
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.text = String(gameTime)

    }


}

