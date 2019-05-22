//
//  CompostQuizViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 25/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class CompostQuizViewController: UIViewController {
    
    var window: UIWindow?
    let quizPickerData = ["Regularly Composite", "Useful Ingredients", "Compost Bin"]
    var dropDownImageViewOne = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Composite"
        self.view.backgroundColor=UIColor.white
        
        createDataSourcePicker()
        createToolBar()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    
    @objc func btnGetStartedAction() {
        let v = QuizVC()
        v.quizType = quizType.text!
        self.navigationController?.pushViewController(v, animated: true)
    }
    
    func setupViews() {
        self.view.addSubview(lblTitle)
        lblTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive=true
        lblTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        lblTitle.widthAnchor.constraint(equalToConstant: 250).isActive=true
        lblTitle.heightAnchor.constraint(equalToConstant: 60).isActive=true
        
        
        self.view.addSubview(subTitle)
        subTitle.heightAnchor.constraint(equalToConstant: 50).isActive=true
        subTitle.widthAnchor.constraint(equalToConstant: 250).isActive=true
        subTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        subTitle.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 0).isActive=true
        
        self.view.addSubview(quizType)
        quizType.heightAnchor.constraint(equalToConstant: 50).isActive=true
        quizType.widthAnchor.constraint(equalToConstant: 300).isActive=true
        quizType.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        quizType.topAnchor.constraint(equalTo: subTitle.bottomAnchor, constant: 60).isActive=true
        
        self.view.addSubview(dropDownImageViewOne)
        dropDownImageViewOne.frame = CGRect(x: 310, y: 290, width: 20, height: 20)
        dropDownImageViewOne.image = UIImage(named: "expand")
        
        self.view.addSubview(btnGetStarted)
        btnGetStarted.heightAnchor.constraint(equalToConstant: 50).isActive=true
        btnGetStarted.widthAnchor.constraint(equalToConstant: 150).isActive=true
        btnGetStarted.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        btnGetStarted.topAnchor.constraint(equalTo: quizType.bottomAnchor, constant: 100).isActive=true
    }
    
    func createDataSourcePicker() {
        let dataSourcePicker = UIPickerView()
        dataSourcePicker.delegate = self
        quizType.inputView = dataSourcePicker
        dataSourcePicker.backgroundColor = .white
    }
    
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CompostQuizViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        quizType.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    let lblTitle: UILabel = {
        let lbl=UILabel()
        lbl.text="Composite Quiz"
        lbl.textColor=UIColor.darkGray
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 30)
        lbl.numberOfLines=2
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let btnGetStarted: UIButton = {
        let btn=UIButton()
        btn.setTitle("Get Started", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Optima", size: 16)
        btn.backgroundColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.textColor = .white
        btn.layer.cornerRadius=5
        btn.layer.masksToBounds=true
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnGetStartedAction), for: .touchUpInside)
        return btn
    }()
    
    let subTitle: UILabel = {
        let lbl=UILabel()
        lbl.text="Check your knowledge of waste good and bad for compost"
        lbl.textColor=UIColor.darkGray
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.numberOfLines=2
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let quizType: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Quiz Type"
        textField.title = "Quiz Type"
        textField.text = "Regularly Composite"
        textField.tintColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        textField.selectedTitleColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        textField.selectedLineColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        textField.translatesAutoresizingMaskIntoConstraints=false
        return textField
    }()
}

extension CompostQuizViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return quizPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(quizPickerData[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        quizType.text = quizPickerData[row]
    }
}
