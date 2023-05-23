//
//  ResultViewController.swift
//  QuizApp
//
//  Created by Apple on 20/05/23.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    
    var result:Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "\(result!) / 10"


    }
    
    @IBAction func backToHomeTapAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
