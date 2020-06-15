//
//  GameScreenViewController.swift
//  Anagram Ice
//
//  Created by Anthony_Kasper on 6/4/20.
//  Copyright © 2020 FirstTry. All rights reserved.
//

import UIKit

class GameScreenViewController: UIViewController {

    @IBOutlet weak var selectedTilesHorizontalStack: UIStackView!
    @IBOutlet weak var availableTilesHorizontalStack: UIStackView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var round:Round?
    var availableTiles:[UIButton] = []
    var selectedTiles:[UIButton] = []
    var guess:[String] = []
    var seconds = 60
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do basic work before establishing the round's model data
        submitButton.alpha = 0
        resultsLabel.alpha = 0
        Game.roundNumber += 1
        self.roundLabel.text = "Round #\(Game.roundNumber)"
        self.scoreLabel.text = "Score: \(Game.score)"
        self.clearButton.alpha = 1.0
        self.timerLabel.text = String(seconds)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
        
        // 1. Randomly select a word
        let targetWord = selectWord(Game.wordLength)
        let wordLetters = LinkedList()
        
        for letter in targetWord {
            round!.rightAnswer += (String(letter))
            wordLetters.append(value: String(letter))
        }

        // 2. Scramble the word's letters
        var scrambledWord:[String] = []

        while wordLetters.count > 0 {
            var indicies:[Int] = []
            for i in 0..<wordLetters.count {
                indicies.append(i)
            }
            let selectedIndex = indicies.randomElement()
            let selectedLetter = wordLetters.removeAt(selectedIndex!)
            scrambledWord.append(selectedLetter)
        }

        // 3. Place letter tiles on screen
        selectedTilesHorizontalStack.alignment = .fill
        selectedTilesHorizontalStack.distribution = .fillEqually
        selectedTilesHorizontalStack.spacing = 5.0

        availableTilesHorizontalStack.alignment = .fill
        availableTilesHorizontalStack.distribution = .fillEqually
        availableTilesHorizontalStack.spacing = 5.0


        for i in scrambledWord {
            let letterButton = UIButton()
            letterButton.layer.cornerRadius = 10
            letterButton.setTitle(i, for: .normal)
            letterButton.backgroundColor = UIColor(red: 71/255, green: 70/255, blue: 69/255, alpha: 1.0)
            letterButton.translatesAutoresizingMaskIntoConstraints = false
            letterButton.addTarget(self, action: #selector(self.bottomLetterButtonPressed(sender:)), for: .touchUpInside)
            availableTiles.append(letterButton)
            availableTilesHorizontalStack.addArrangedSubview(letterButton)

            let placeHolder = UIButton()
            placeHolder.layer.cornerRadius = 10
            placeHolder.backgroundColor = UIColor(red: 71/255, green: 70/255, blue: 69/255, alpha: 0.8)
            placeHolder.alpha = 0
            placeHolder.translatesAutoresizingMaskIntoConstraints = false
            placeHolder.addTarget(self, action: #selector(self.topLetterButtonPressed(sender:)), for: .touchUpInside)
            selectedTiles.append(placeHolder)
            selectedTilesHorizontalStack.addArrangedSubview(placeHolder)
        }
    }
    
    @objc func bottomLetterButtonPressed(sender: UIButton) {

        if round!.topLetterPos < round!.getWordLength() {

            let title = sender.title(for: .normal)!
            selectedTiles[round!.topLetterPos].setTitle(title, for: .normal)
            round!.guess.append(title)

            // When pressed, the button should fade out while a button fades in above
            UIView.animate(withDuration: 0.50) {
                self.selectedTiles[self.round!.topLetterPos].alpha = 1.0
            }
            UIView.animate(withDuration: 0.50) {
                sender.alpha = 0.0
            }

            if round!.topLetterPos == (round!.getWordLength() - 1) {
                UIView.animate(withDuration: 0.5) {
                    self.submitButton.alpha = 1.0
                }
            }
            round!.topLetterPos = round!.topLetterPos + 1
        }
    }

    @objc func topLetterButtonPressed(sender: UIButton) {
        // Only works on the most recently set tile
        if sender.title(for: .normal) == "A" {
            
        }
    }

    @IBAction func submitButtonPressed(_ sender: UIButton) {

        if round!.guess == round!.rightAnswer {
            
            //Increment player's score for this game for figuring out the secret word
            Game.score += 1

            // Temporarily remove the option to clear and sbumit once the guess has been submitted
            self.clearButton.alpha = 0.0
            self.submitButton.alpha = 0.0
            
            //Change the tiles to the color green to reflect the correct answer
            for tile in self.selectedTilesHorizontalStack!.arrangedSubviews {
                tile.backgroundColor = UIColor(red: 123/255, green: 227/255, blue: 126/255, alpha: 1.0)
            }
            
            // Tell the player that they were correct, clean up the gameboard, reset the round, and reload the screen to a new round
            UIView.animate(withDuration: 0.25) {
                self.resultsLabel.textColor = UIColor(red: 123/255, green: 227/255, blue: 126/255, alpha: 1.0)
                self.resultsLabel.text = "CORRECT!"
                self.resultsLabel.alpha = 1.0
                UIView.animate(withDuration: 0.25,
                           delay: 2,
                           animations: {self.resultsLabel.alpha = 0.0},
                           completion: {(true) in
                            //clear out the contents of this view
                            self.availableTiles.removeAll()
                            self.selectedTiles.removeAll()
                            for subview in self.selectedTilesHorizontalStack!.arrangedSubviews {
                                self.selectedTilesHorizontalStack.removeArrangedSubview(subview)
                                subview.removeFromSuperview()
                            }
                            for subview in self.availableTilesHorizontalStack!.arrangedSubviews {
                                self.availableTilesHorizontalStack.removeArrangedSubview(subview)
                                subview.removeFromSuperview()
                            }
                            self.round!.reset()
                            self.viewDidLoad()
                })
            }
        }
            
        else {
            // Temporarily remove the option to clear and submit once the guess has been submitted
            self.clearButton.alpha = 0.0
            self.submitButton.alpha = 0.0
            
            //Change the tiles to the color red to reflect the wrong answer
            for tile in self.selectedTilesHorizontalStack!.arrangedSubviews {
                tile.backgroundColor = UIColor(red: 227/255, green: 54/255, blue: 54/255, alpha: 1.0)
            }
            UIView.animate(withDuration: 0.25) {
                self.resultsLabel.textColor = UIColor(red: 227/255, green: 54/255, blue: 54/255, alpha: 1.0)
                self.resultsLabel.text = "WRONG, TRY AGAIN!"
                self.resultsLabel.alpha = 1.0
            }
            
            UIView.animate(withDuration: 0.25,
                           delay: 2,
                           animations: {self.resultsLabel.alpha = 0.0},
                           completion: {(true) in
                                for selectedTile in self.selectedTilesHorizontalStack!.arrangedSubviews {selectedTile.backgroundColor = UIColor(red: 71/255, green: 70/255, blue: 69/255, alpha: 0.8)}
                                self.submitButton.alpha = 0.0
                                self.clearButton.alpha = 1.0
                                self.clearButtonPressed(self)
                            })
        }
    }

    @IBAction func clearButtonPressed(_ sender: Any?) {
        round!.topLetterPos = 0
        round!.guess = ""
        
        for tileButton in selectedTiles {
            UIView.animate(withDuration: 0.25) {
                tileButton.alpha = 0
            }
        }
        for tileButton in availableTiles {
            UIView.animate(withDuration: 0.25) {
                tileButton.alpha = 1.0
            }
        }
    }
    
    func selectWord(_ wordLength:Int) -> String {
        var targetWord:String = ""
        if wordLength == 5 {
            targetWord = WordBank.five.randomElement()!
        }
        else if wordLength == 6 {
            targetWord = WordBank.six.randomElement()!
        }
        else if wordLength == 7 {
            targetWord = WordBank.seven.randomElement()!
        }
        return targetWord
    }
    
    @objc func countDown() {
        seconds -= 1
        timerLabel.text = String(seconds)
        
        if (seconds == 0) {
            timer.invalidate()
            
            // Call for a transition once the timer hits 0
            print("DONE")
            performSegue(withIdentifier: "showResultsSegue", sender: self)
        }
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showResultsSegue" {
//        }
//    }
}
