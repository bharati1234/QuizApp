//
//  QuizCollectionViewCell.swift
//  QuizApp
//
//  Created by Apple on 18/05/23.
//

import UIKit

protocol BackActionDelegate: AnyObject {
    func answerClicked(answer: String)
}

class QuizCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var option1: UIButton!
    
    @IBOutlet weak var option2: UIButton!
    
    @IBOutlet weak var option3: UIButton!
    
    @IBOutlet weak var option4: UIButton!
  
    weak var actionDelegate: BackActionDelegate?
    
    var selectedAnswer = ""
    var correctAnswer = ""
    
    static let identifier = "QuizCollectionViewCell"
    
    static func nib()->UINib{
        return UINib(nibName: "QuizCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    @IBAction func clickOption(_ sender: UIButton) {
        
        option1.layer.borderWidth = 0.0
        option2.layer.borderWidth = 0.0
        option3.layer.borderWidth = 0.0
        option4.layer.borderWidth = 0.0

        sender.layer.borderWidth = 2.0
        sender.layer.borderColor = UIColor.red.cgColor
        
        selectedAnswer = sender.currentTitle!
        //print(selectedAnswer)
        
        actionDelegate?.answerClicked(answer: selectedAnswer)
       
    }
   
    
    func configureQuestions(question:questions){
        option1.layer.borderWidth = 0.0
        option2.layer.borderWidth = 0.0
        option3.layer.borderWidth = 0.0
        option4.layer.borderWidth = 0.0
        
        
        questionLabel.text = question.question
        option1.setTitle(question.option_1, for: .normal)
        option2.setTitle(question.option_2, for: .normal)
        option3.setTitle(question.option_3, for: .normal)
        option4.setTitle(question.option_4, for: .normal)
    }
        
}


