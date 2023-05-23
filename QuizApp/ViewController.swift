//
//  ViewController.swift
//  QuizApp
//
//  Created by Apple on 18/05/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    @IBAction func onClickPlay(_ sender: Any) {
        
      let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let quizVC = storyBoard.instantiateViewController(withIdentifier: "QuizViewController") as! QuizViewController
        self.navigationController?.pushViewController(quizVC, animated: true)
    }
    @IBAction func onClickTopic(_ sender: Any) {
    }
}

