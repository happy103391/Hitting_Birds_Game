

import UIKit

class LeaderboardVC: UIViewController {
    
    let defaults = UserDefaults.standard
    
    
    @IBOutlet var lastResultLabel: [UILabel]!
    
    
    @IBOutlet var rankLabel: [UILabel]!
    
    @IBAction func returnButtonPressed(_ sender: Any) {

    }
    
    
    func displayLastResult(){
        
        // Check if there are previous game results
        if defaults.array(forKey: "ResultArray") != nil {
            let latestResultArray = defaults.array(forKey: "ResultArray") as! [Int]
            lastResultLabel[0].text = "Blue Bird : \(latestResultArray[0])"
            lastResultLabel[1].text = "Brown Bird : \(latestResultArray[1])"
            lastResultLabel[2].text = "Black Bird : \(latestResultArray[2])"
            lastResultLabel[3].text = "Total Score : \(latestResultArray[3])"
        } else {
            lastResultLabel[0].text = "Blue Bird : 0"
            lastResultLabel[1].text = "Brown Bird : 0"
            lastResultLabel[2].text = "Black Bird : 0"
            lastResultLabel[3].text = "Total Score: 0"
        }
        
        
    }
    
    func displayRank(){
        if defaults.array(forKey: "ScoreArray") != nil {
            let scoreArray = defaults.array(forKey: "ScoreArray") as! [Int]
            rankLabel[0].text = "1st \(scoreArray[0])"
            rankLabel[1].text = "2nd \(scoreArray[1])"
            rankLabel[2].text = "3rd \(scoreArray[2])"
            rankLabel[3].text = "4th \(scoreArray[3])"
            rankLabel[4].text = "5th \(scoreArray[4])"
        } else {
            rankLabel[0].text = "1st 0"
            rankLabel[1].text = "2nd 0"
            rankLabel[2].text = "3rd 0"
            rankLabel[3].text = "4th 0"
            rankLabel[4].text = "5th 0"
        }
        
        
    }
    
    
    override func viewDidLoad() {
//        執行上面的兩個method，分別是呈現最近一次的結果，以及遊戲的總排名
        super.viewDidLoad()
        displayLastResult()
        displayRank()
    }
    
}
