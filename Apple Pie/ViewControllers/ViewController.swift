//
//  ViewController.swift
//  Apple Pie
//
//  Created by Gordon Choi on 2021/04/08.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var treeImageView: UIImageView! // IBOutlet 변수
    @IBOutlet private var correctWordLabel: UILabel!
    @IBOutlet private var scoreLabel: UILabel!
    @IBOutlet private var letterButtons: [UIButton]!

    private var listOfWords = ["buccaneer", "swift", "glorious", "incandescent", "bug", "program"] // 일반 변수 및 상수
    private let incorrectMovesAllowed = 7
    private var totalWins = 0 {
        didSet { newRound() }
    }
    private var totalLosses = 0 {
        didSet { newRound() }
    }
    private var currentGame: Game!
}
    
extension ViewController { // view 관련 코드
    override func viewDidLoad() {
        super.viewDidLoad()
        newRound()
    }
}

extension ViewController { // 라이프사이클 관련 코드
    private func updateUI() {
        var letters = [String]()
        for letter in currentGame.formattedWord {
            letters.append(String(letter))
        }
        let wordWithSpacing = letters.joined(separator: " ")
        correctWordLabel.text = wordWithSpacing
        scoreLabel.text = "Wins: \(totalWins), Losses: \(totalLosses)"
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMoveRemaining)")
    }
    
    private func enableLetterButtons(_ enable: Bool) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }
}
    
    
extension ViewController { // 로직 관련 코드
    private func newRound() {
        let num = Int.random(in: 0...listOfWords.count-1)
        if !listOfWords.isEmpty {
            let newWord = listOfWords.remove(at: num)
            currentGame = Game(word: newWord, incorrectMoveRemaining: incorrectMovesAllowed, guessedLetters: [])
            enableLetterButtons(true)
            updateUI()
        } else {
            enableLetterButtons(false)
        }
    }
    
    private func updateGameState() {
        if currentGame.incorrectMoveRemaining == 0 {
            totalLosses += 1
        } else if currentGame.word == currentGame.formattedWord {
            totalWins += 1
        } else {
            updateUI()
        }
    }
}
    
extension ViewController { // IBAction 코드
    @IBAction private func buttonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        let letterString = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateGameState()
    }
}

