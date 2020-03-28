//
//  ViewController.swift
//  Flashcards
//
//  Created by Li, Jessica on 2/15/20.
//  Copyright © 2020 Jessie Li. All rights reserved.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
    var extraAnswerOne: String
    var extraAnswerTwo: String
}
class ViewController: UIViewController {
    
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var btnOptionOne: UIButton!
    @IBOutlet weak var btnOptionTwo: UIButton!
    @IBOutlet weak var btnOptionThree: UIButton!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var flashcards = [Flashcard]()
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        card.layer.cornerRadius = 20.0
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 0.2
        frontLabel.layer.cornerRadius = 20.0
        backLabel.layer.cornerRadius = 20.0
        frontLabel.clipsToBounds = true
        backLabel.clipsToBounds = true
        btnOptionOne.layer.cornerRadius = 20.0
        btnOptionOne.layer.borderWidth = 3.0
        btnOptionOne.layer.borderColor = #colorLiteral(red: 1, green: 0.5772911906, blue: 0.002968993504, alpha: 1)
        btnOptionTwo.layer.cornerRadius = 20.0
        btnOptionTwo.layer.borderWidth = 3.0
        btnOptionTwo.layer.borderColor = #colorLiteral(red: 1, green: 0.5772911906, blue: 0.002968993504, alpha: 1)
        btnOptionThree.layer.cornerRadius = 20.0
        btnOptionThree.layer.borderWidth = 3.0
        btnOptionThree.layer.borderColor = #colorLiteral(red: 1, green: 0.5772911906, blue: 0.002968993504, alpha: 1)
        
        readSavedFlashcards()
        
        if flashcards.count == 0 {
            updateFlashcard(question: "What's the capital of Rhode Island?", answer: "Providence", extraAnswerOne: "Reno", extraAnswerTwo: "Boston", isExisting: false)
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard() {
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
            if (self.frontLabel.isHidden == true) {
                self.frontLabel.isHidden = false
            } else {
                self.frontLabel.isHidden = true
            }
        })
    }
    
    func updateFlashcard(question: String, answer: String, extraAnswerOne: String, extraAnswerTwo: String, isExisting: Bool) {
        let flashcard = Flashcard(question: question, answer: answer, extraAnswerOne: extraAnswerOne, extraAnswerTwo: extraAnswerTwo)
        
        if isExisting {
            flashcards[currentIndex] = flashcard
        } else {
            flashcards.append(flashcard)
            
            print("Added new flashcard")
            print("We now have \(flashcards.count) flashcards")
            currentIndex = flashcards.count - 1
            print("Our current index is \(currentIndex)")
        }
        
        updateLabels()
        updateNextPrevButtons()
        saveAllFlashcardsToDisk()
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        currentIndex = currentIndex - 1
        animateCardOutPrev()
        updateNextPrevButtons()
    }
    
    func animateCardOutPrev() {
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: 300, y: 0)
        }, completion: { finished in
            self.updateLabels()
            self.animateCardInPrev()
        })
    }
    
    func animateCardInPrev() {
        card.transform = CGAffineTransform.identity.translatedBy(x: -300, y: 0)
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        currentIndex = currentIndex + 1
        animateCardOutNext()
        updateNextPrevButtons()
    }
    
    func animateCardOutNext() {
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300, y: 0)
        }, completion: { finished in
            self.updateLabels()
            self.animateCardInNext()
        })
    }
    
    func animateCardInNext() {
        card.transform = CGAffineTransform.identity.translatedBy(x: 300, y: 0)
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func didTapOptionOne(_ sender: Any) {
        btnOptionOne.isHidden = true
    }
    
    @IBAction func didTapOptionTwo(_ sender: Any) {
        frontLabel.isHidden = true
    }
    
    @IBAction func didTapOptionThree(_ sender: Any) {
        btnOptionThree.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let creationController = navigationController.topViewController as! CreationViewController
        creationController.flashcardsController = self
        if segue.identifier == "EditSegue" {
            creationController.initialQuestion = frontLabel.text
            creationController.initialAnswer = backLabel.text
        }
    }
    
    func updateNextPrevButtons() {
        if currentIndex == flashcards.count - 1 || flashcards.count == 0 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        if currentIndex == 0 || flashcards.count == 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
    }
    
    func updateLabels() {
        let currentFlashcard = flashcards[currentIndex]
        
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
        btnOptionOne.setTitle(currentFlashcard.extraAnswerOne, for: .normal)
        btnOptionTwo.setTitle(currentFlashcard.answer, for: .normal)
        btnOptionThree.setTitle(currentFlashcard.extraAnswerTwo, for: .normal)
    }
    
    func saveAllFlashcardsToDisk() {
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer, "extra1": card.extraAnswerOne, "extra2": card.extraAnswerTwo]
        }
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        print("Flashcards saved to UserDefaults")
    }
    
    func readSavedFlashcards() {
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!, extraAnswerOne: dictionary["extra1"]!, extraAnswerTwo: dictionary["extra2"]!)
            }
            flashcards.append(contentsOf: savedCards)
        }
    }
    
    @IBAction func didTapOnDelete(_ sender: Any) {
        let alert = UIAlertController(title: "Delete flashcard", message: "Are you sure you want to delete this flashcard?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            self.deleteCurrentFlashcard()
        }
        alert.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func deleteCurrentFlashcard() {
        flashcards.remove(at: currentIndex)
         
        if currentIndex > flashcards.count - 1 && flashcards.count > 1 {
            currentIndex = flashcards.count - 1
        }
        print(currentIndex)
        updateNextPrevButtons()
        if flashcards.count == 0 {
            frontLabel.text = ""
            backLabel.text = ""
        } else {
            updateLabels()
        }
        saveAllFlashcardsToDisk()
    }
}

