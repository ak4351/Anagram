//
//  ResultsViewController.swift
//  Anagram Ice
//
//  Created by Anthony_Kasper on 6/14/20.
//  Copyright © 2020 FirstTry. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "Final Score: \(Game.score)"
    }
    

    @IBAction func playAgainButtonPressed(_ sender: Any) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
