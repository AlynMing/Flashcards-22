//
//  ViewController.swift
//  Flashcards
//
//  Created by Li, Jessica on 2/15/20.
//  Copyright © 2020 Jessie Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var answer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        question.isHidden = true;
    }
    
}

