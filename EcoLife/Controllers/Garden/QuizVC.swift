//
//  QuizVC.swift
//  EcoLife
//
//  Created by 姚逸晨 on 25/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit

struct Question {
    let imgName: String
    let questionText: String
    let options: [String]
    let correctAns: Int
    var wrongAns: Int
    var isAnswered: Bool
}

class QuizVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var myCollectionView: UICollectionView!
    var questionsArray = [Question]()
    var score: Int = 0
    var currentQuestionNumber = 1
    var quizType = ""
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Quizs"
        self.view.backgroundColor=UIColor.white
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        myCollectionView=UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), collectionViewLayout: layout)
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(QuizCVCell.self, forCellWithReuseIdentifier: "Cell")
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints=false
        myCollectionView.backgroundColor=UIColor.white
        myCollectionView.isPagingEnabled = true
        
        self.view.addSubview(myCollectionView)
        
        self.getQuizQuestions(quizType: quizType)
        
        setupViews()
    }
    
    func getQuizQuestions(quizType: String) {
        
        if quizType == "Regularly Composite" {
            let que1 = Question(imgName: "egg_shell", questionText: "Which one is good for daily composite ?", options: ["Egg shells", "Cane mulch", "Paper", "Magazines"], correctAns: 0, wrongAns: -1, isAnswered: false)
            let que2 = Question(imgName: "weeds", questionText: "Which one is good for daily composite ?", options: ["Straw", "Dry leaves", "Large branches", "Weeds"], correctAns: 3, wrongAns: -1, isAnswered: false)
            let que3 = Question(imgName: "hay", questionText: "Which one is not good for daily composite ?", options: ["Cooking oil", "Sawdust ashe", "Hay", "Human hair"], correctAns: 2, wrongAns: -1, isAnswered: false)
            let que4 = Question(imgName: "soil", questionText: "Which one is not good for weekly composite ?", options: ["Bark", "Grass clippings", "Egg cartons", "Soil"], correctAns: 3, wrongAns: -1, isAnswered: false)
            let que5 = Question(imgName: "tree_prunings", questionText: "Which one is good for weekly composite ?", options: ["Tree prunings", "Dairy products", "Fat", "Lime"], correctAns: 0, wrongAns: -1, isAnswered: false)
            let que6 = Question(imgName: "plastic_bags", questionText: "Which one is not good for composite?", options: ["Newspapers", "Coffee grounds", "Plastic bags", "Fruit peelings"], correctAns: 2, wrongAns: -1, isAnswered: false)
            
            questionsArray = [que1, que2, que3, que4, que5, que6]
        }
        else if quizType == "Useful Integredients" {
            let que1 = Question(imgName: "blood_bone", questionText: "Which ingredient is useful ?", options: ["Paper ashe", "Blood and bone", "Glass", "Tea leaves"], correctAns: 1, wrongAns: -1, isAnswered: false)
            let que2 = Question(imgName: "metals", questionText: "Which ingredient is not useful ?", options: ["Wood ashe", "Dynamic lifter", "Dolomite", "Metals"], correctAns: 3, wrongAns: -1, isAnswered: false)
            
            questionsArray = [que1, que2]
        }
        else if quizType == "Compost Bin" {
            let que1 = Question(imgName: "cardboard", questionText: "Which can be put in compost bin ?", options: ["Large branches", "Diseased plant", "Cardboard", "Magazines"], correctAns: 2, wrongAns: -1, isAnswered: false)
            let que2 = Question(imgName: "paper", questionText: "Which cannot be put in compost bin ?", options: ["Paper", "Pet droppings", "Meat scraps", "Bread"], correctAns: 0, wrongAns: -1, isAnswered: false)
            let que3 = Question(imgName: "cleaner_dust", questionText: "Which can be put in compost bin ?", options: ["Cleaner dust", "Bones", "Cake", "Fat"], correctAns: 0, wrongAns: -1, isAnswered: false)
            
            questionsArray = [que1, que2, que3]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! QuizCVCell
        cell.question=questionsArray[indexPath.row]
        cell.delegate=self
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setQuestionNumber()
    }
    
    func setQuestionNumber() {
        let x = myCollectionView.contentOffset.x
        let w = myCollectionView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        if currentPage < questionsArray.count {
            lblQueNumber.text = "Question: \(currentPage+1) / \(questionsArray.count)"
            currentQuestionNumber = currentPage + 1
        }
    }
    
    @objc func btnPrevNextAction(sender: UIButton) {
        if sender == btnNext && currentQuestionNumber == questionsArray.count {
            let v=ResultVC()
            v.score = score
            v.totalScore = questionsArray.count
            self.navigationController?.pushViewController(v, animated: false)
            return
        }
        
        let collectionBounds = self.myCollectionView.bounds
        var contentOffset: CGFloat = 0
        if sender == btnNext {
            contentOffset = CGFloat(floor(self.myCollectionView.contentOffset.x + collectionBounds.size.width))
            currentQuestionNumber += currentQuestionNumber >= questionsArray.count ? 0 : 1
        } else {
            contentOffset = CGFloat(floor(self.myCollectionView.contentOffset.x - collectionBounds.size.width))
            currentQuestionNumber -= currentQuestionNumber <= 0 ? 0 : 1
        }
        self.moveToFrame(contentOffset: contentOffset)
        lblQueNumber.text = "Question: \(currentQuestionNumber) / \(questionsArray.count)"
    }
    
    func moveToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : self.myCollectionView.contentOffset.y ,width : self.myCollectionView.frame.width,height : self.myCollectionView.frame.height)
        self.myCollectionView.scrollRectToVisible(frame, animated: true)
    }
    
    func setupViews() {
        myCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive=true
        myCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive=true
        myCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive=true
        myCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive=true
        
        self.view.addSubview(btnPrev)
        btnPrev.heightAnchor.constraint(equalToConstant: 50).isActive=true
        btnPrev.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive=true
        btnPrev.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive=true
        btnPrev.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive=true
        
        self.view.addSubview(btnNext)
        btnNext.heightAnchor.constraint(equalTo: btnPrev.heightAnchor).isActive=true
        btnNext.widthAnchor.constraint(equalTo: btnPrev.widthAnchor).isActive=true
        btnNext.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive=true
        btnNext.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive=true
        
        self.view.addSubview(lblQueNumber)
        lblQueNumber.heightAnchor.constraint(equalToConstant: 20).isActive=true
        lblQueNumber.widthAnchor.constraint(equalToConstant: 150).isActive=true
        lblQueNumber.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive=true
        lblQueNumber.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive=true
        lblQueNumber.text = "Question: \(1) / \(questionsArray.count)"
        
        self.view.addSubview(lblScore)
        lblScore.heightAnchor.constraint(equalTo: lblQueNumber.heightAnchor).isActive=true
        lblScore.widthAnchor.constraint(equalTo: lblQueNumber.widthAnchor).isActive=true
        lblScore.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive=true
        lblScore.bottomAnchor.constraint(equalTo: lblQueNumber.bottomAnchor).isActive=true
        lblScore.text = "Score: \(score) / \(questionsArray.count)"
    }
    
    let btnPrev: UIButton = {
        let btn=UIButton()
        btn.setTitle("< Previous", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor=UIColor.orange
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnPrevNextAction), for: .touchUpInside)
        return btn
    }()
    
    let btnNext: UIButton = {
        let btn=UIButton()
        btn.setTitle("Next >", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor=UIColor.purple
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnPrevNextAction), for: .touchUpInside)
        return btn
    }()
    
    let lblQueNumber: UILabel = {
        let lbl=UILabel()
        lbl.text="0 / 0"
        lbl.textColor=UIColor.gray
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let lblScore: UILabel = {
        let lbl=UILabel()
        lbl.text="0 / 0"
        lbl.textColor=UIColor.gray
        lbl.textAlignment = .right
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
}

extension QuizVC: QuizCVCellDelegate {
    func didChooseAnswer(btnIndex: Int) {
        let centerIndex = getCenterIndex()
        guard let index = centerIndex else { return }
        questionsArray[index.item].isAnswered=true
        if questionsArray[index.item].correctAns != btnIndex {
            questionsArray[index.item].wrongAns = btnIndex
            //score -= 1
        } else {
            score += 1
        }
        lblScore.text = "Score: \(score) / \(questionsArray.count)"
        myCollectionView.reloadItems(at: [index])
    }
    
    func getCenterIndex() -> IndexPath? {
        let center = self.view.convert(self.myCollectionView.center, to: self.myCollectionView)
        let index = myCollectionView!.indexPathForItem(at: center)
        print(index ?? "index not found")
        return index
    }
}

