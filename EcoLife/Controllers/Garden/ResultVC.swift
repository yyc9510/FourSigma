//
//  ResultVC.swift
//  EcoLife
//
//  Created by 姚逸晨 on 25/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit

class ResultVC: UIViewController {
    
    var score: Int?
    var totalScore: Int?
    var wrongQuestions = [Question]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        self.view.backgroundColor = .white
        setupViews()
    }
    
    func showRating() {
        var rating = ""
        var color = UIColor.white
        guard let sc = score, let tc = totalScore else { return }
        let s = sc * 100 / tc
        if s < 40 {
            rating = "Poor"
            color = UIColor.darkGray
        }  else if s < 60 {
            rating = "Good"
            color = UIColor.blue
        } else if s < 90 {
            rating = "Excellent"
            color = UIColor.red
        } else if s <= 100 {
            rating = "Outstanding"
            color = UIColor.orange
        }
        lblRating.text = "\(rating)"
        lblRating.textColor=color
    }
    
    @objc func btnRestartAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func checkResult() {
        let vc = ResultsViewController()
        vc.wrongQuestions = wrongQuestions
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func setupViews() {
        self.view.addSubview(lblTitle)
        lblTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive=true
        lblTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        lblTitle.widthAnchor.constraint(equalToConstant: 250).isActive=true
        lblTitle.heightAnchor.constraint(equalToConstant: 80).isActive=true
        
        self.view.addSubview(lblScore)
        lblScore.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 50).isActive=true
        lblScore.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        lblScore.widthAnchor.constraint(equalToConstant: 150).isActive=true
        lblScore.heightAnchor.constraint(equalToConstant: 60).isActive=true
        lblScore.text = "\(score!) / \(totalScore!)"
        
        self.view.addSubview(lblRating)
        lblRating.topAnchor.constraint(equalTo: lblScore.bottomAnchor, constant: 50).isActive=true
        lblRating.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        lblRating.widthAnchor.constraint(equalToConstant: 150).isActive=true
        lblRating.heightAnchor.constraint(equalToConstant: 60).isActive=true
        showRating()
        
        if wrongQuestions.isEmpty {
            self.view.addSubview(btnRestart)
            btnRestart.topAnchor.constraint(equalTo: lblRating.bottomAnchor, constant: 50).isActive=true
            btnRestart.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
            btnRestart.widthAnchor.constraint(equalToConstant: 150).isActive=true
            btnRestart.heightAnchor.constraint(equalToConstant: 50).isActive=true
            btnRestart.addTarget(self, action: #selector(btnRestartAction), for: .touchUpInside)
        }
        else {
            self.view.addSubview(wrongQuestion)
            wrongQuestion.topAnchor.constraint(equalTo: lblRating.bottomAnchor, constant: 30).isActive=true
            wrongQuestion.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
            wrongQuestion.widthAnchor.constraint(equalToConstant: 150).isActive=true
            wrongQuestion.heightAnchor.constraint(equalToConstant: 50).isActive=true
            wrongQuestion.addTarget(self, action: #selector(checkResult), for: .touchUpInside)

            self.view.addSubview(btnRestart)
            btnRestart.topAnchor.constraint(equalTo: wrongQuestion.bottomAnchor, constant: 20).isActive=true
            btnRestart.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
            btnRestart.widthAnchor.constraint(equalToConstant: 150).isActive=true
            btnRestart.heightAnchor.constraint(equalToConstant: 50).isActive=true
            btnRestart.addTarget(self, action: #selector(btnRestartAction), for: .touchUpInside)
        }
    }
    
    let lblTitle: UILabel = {
        let lbl=UILabel()
        lbl.text="Your Score"
        lbl.textColor=UIColor.darkGray
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 46)
        lbl.numberOfLines=2
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let lblScore: UILabel = {
        let lbl=UILabel()
        lbl.text="0 / 0"
        lbl.textColor=UIColor.black
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let lblRating: UILabel = {
        let lbl=UILabel()
        lbl.text="Good"
        lbl.textColor=UIColor.black
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let btnRestart: UIButton = {
        let btn = UIButton()
        btn.setTitle("Go Back", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor=UIColor.orange
        btn.layer.cornerRadius=5
        btn.clipsToBounds=true
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    let wrongQuestion: UIButton = {
        let btn = UIButton()
        btn.setTitle("Review", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor=UIColor.orange
        btn.layer.cornerRadius=5
        btn.clipsToBounds=true
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
}

