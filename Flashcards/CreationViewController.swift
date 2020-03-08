//
//  CreationViewController.swift
//  Flashcards
//
//  Created by Li, Jessica on 2/29/20.
//  Copyright © 2020 Jessie Li. All rights reserved.
//

import UIKit

class CreationViewController: UIViewController {
    
    var flashcardsController: ViewController!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var extraAnswerOne: UITextField!
    @IBOutlet weak var extraAnswerTwo: UITextField!
    var initialQuestion: String?
    var initialAnswer: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionTextField.text = initialQuestion
        answerTextField.text = initialAnswer
    }
    
    @IBAction func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapOnDone(_ sender: Any) {
        // get text in the question and answer fields
        let questionText = questionTextField.text
        let answerText = answerTextField.text
        let extraAnswerOneText = extraAnswerOne.text
        let extraAnswerTwoText = extraAnswerTwo.text
        if questionText == nil || answerText == nil || questionText!.isEmpty || answerText!.isEmpty {
            let alert = UIAlertController(title: "Missing text", message: "Need to enter both a question and an answer", preferredStyle: .alert)
            present(alert, animated: true)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
        } else {
            flashcardsController.updateFlashcard(question: questionText!, answer: answerText!, extraAnswerOne: extraAnswerOneText, extraAnswerTwo: extraAnswerTwoText)
            dismiss(animated: true)
        }
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
