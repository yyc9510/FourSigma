//
//  ResultsViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 27/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit

class ResultsViewController: UITableViewController {
    
    var wrongQuestions: [Question] = []
    var correct = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Review"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "resultCell")
        
        for question in wrongQuestions {
            var pair = [String]()
            pair.append(question.options[question.wrongAns])
            pair.append(question.options[question.correctAns])
            correct.append(pair)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return wrongQuestions.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        
        var label = ""
        if indexPath.row == 0 {
            label = "Your answer is:"
        }
        else {
            label = "The correct answer is:"
        }
        cell.textLabel?.text = "\(label) \(correct[indexPath.section][indexPath.row])"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        
        let label = UILabel()
        label.text = "Q: \(wrongQuestions[section].questionText)"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.frame = CGRect(x: 20, y: 20, width: 400, height: 15)

        view.addSubview(label)
        
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
}
