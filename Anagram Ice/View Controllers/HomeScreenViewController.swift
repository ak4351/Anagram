//
//  ViewController.swift
//  Anagram Ice
//
//  Created by Anthony_Kasper on 6/4/20.
//  Copyright © 2020 FirstTry. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var playNowButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wordLengthLabel: UILabel!
    @IBOutlet weak var wordLengthStepper: UIStepper!
    
    var round = Round()
    
    enum Segues {
        static let toRoomList = "playGameSegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.numberOfLines = 1
        titleLabel.text = "Welcome!"
        playNowButton.layer.cornerRadius = 15
    }

    @IBAction func playNowButtonClicked(_ sender: Any) {
        Game.roundNumber = 0
        Game.score = 0
        Game.wordLength = Int(wordLengthLabel.text!)!
    }
    
      
    @IBAction func selectorPressed(_ sender: UIStepper) {
        wordLengthLabel.text = String(Int(sender.value))
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toRoomList {
            let controller = segue.destination as! GameScreenViewController
            controller.round = self.round
        }
    }
    
}

