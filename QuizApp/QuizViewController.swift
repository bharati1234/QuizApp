//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Apple on 18/05/23.
//

import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var questionDataArray = [questions]()
    var currentQuestionIndex = 0
    var selectedAnswer = ""
    //var correctAnswer = [String]()
    
    var score = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(QuizCollectionViewCell.nib(), forCellWithReuseIdentifier: QuizCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        apiToGetQuestionData()
        
    }
    
    @IBAction func moveToNextQuestion(_ sender: UIButton) {
        if selectedAnswer.isEmpty{
            let alertController = UIAlertController(title: "Select One Option", message: "You have to choose any one option before moving to next question", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default )
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        
        
        let currentQuestionObj = questionDataArray[currentQuestionIndex]
        let correctAnswer = currentQuestionObj.correct_answer
        
        if(correctAnswer == selectedAnswer){
            score += 1
            
        }
        
        if currentQuestionIndex < questionDataArray.count - 1
        {
            currentQuestionIndex += 1
            let scrollToIndex = IndexPath(item: currentQuestionIndex, section: 0)
            collectionView.scrollToItem(at: scrollToIndex, at: .right, animated: true)
            selectedAnswer = ""
            
            //print("score,\(score)")
            
            
        }else{
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let resultVC = storyBoard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
            resultVC.result = score
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
        // selectedAnswer = ""
    }
    
    func apiToGetQuestionData(){
        
        let url = URL(string: "https://quiz-68112-default-rtdb.firebaseio.com/quiz.json")
        let task = URLSession.shared.dataTask(with: url!,
                                              completionHandler: { (Data, response, error) in
            
            guard let data = Data,error == nil else
            {
                print("Error Occured while accessing data")
                return
            }
            do{
                let jsonDataObj = try JSONSerialization.jsonObject(with: data)
                
                guard let dictionaryData = jsonDataObj as? [String: Any] else {
                    print("Error: invalid JSON format")
                    return
                }
                //print("json",dictionary)
                
                guard let data = dictionaryData["data"] as? [String: Any] else {
                    print("Error: missing 'data' field")
                    return
                }
                guard let questionsListData = data["questions"] as? [[String: Any]] else {
                    print("Error: missing 'questions' field")
                    return
                }
                
                for questionData in questionsListData {
                    guard let option1 = questionData["option_1"] as? String else{
                        print("Error: missing 'option_1' field")
                        return
                    }
                    
                    guard let option2 = questionData["option_2"] as? String else{
                        print("Error: missing 'option_2' field")
                        return
                    }
                    
                    guard let option3 = questionData["option_3"] as? String else{
                        print("Error misssing 'option_3' filed")
                        return
                    }
                    guard let option4 = questionData["option_4"] as? String else{
                        print("Error missing 'option4' field")
                        return
                    }
                    guard let question = questionData["question"] as? String else{
                        print("Error missing 'question' field")
                        return
                    }
                    guard let correctanswer = questionData["correct_answer"] as? String else{
                        print("Error missing 'correct_answer' field")
                        return
                    }
                    
                    let questionData = questions(correct_answer: correctanswer, option_1: option1, option_2: option2, option_3: option3, option_4: option4, question: question)
                    
                    //print(questionData)
                    self.questionDataArray.append(questionData)
                    //self.correctAnswer.append(questionData.correct_answer)
                    //print(self.correctAnswer)
                    
                }
                //print(self.questionDataArray)
                
                
            }
            catch{
                print("Eroor while decoding json into swift srtructure \(error)")
            }
            
            
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        })//closure
        task.resume()
        
    }//function
    
}//class

extension QuizViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuizCollectionViewCell.identifier, for: indexPath) as! QuizCollectionViewCell
        
        cell.configureQuestions(question: questionDataArray[indexPath.row])
        cell.actionDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        let collectionHeight = collectionView.bounds.height
        
        return CGSize(width: collectionWidth, height: collectionHeight)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
}

extension QuizViewController: BackActionDelegate {
    
    func answerClicked(answer: String) {
        selectedAnswer = answer
    }
}
