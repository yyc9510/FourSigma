//
//  CustomCell.swift
//  EcoLife
//
//  Created by 姚逸晨 on 25/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    let screenW : CGFloat = UIScreen.main.bounds.size.width
    let screenH : CGFloat = UIScreen.main.bounds.size.height
    
    var lineViewArray = [UIView]()
    let paramsDict = ["january":"0","february":"1","march":"2","april":"3","may":"4","june":"5","july":"6","august":"7","september":"8","october":"9","november":"10","december":"11"]
    
    var monthArray : [String] = [String](){
        didSet{
            for i  in 0..<lineViewArray.count {
                let lineView = lineViewArray[i]
                lineView.isHidden = true
                
            }
            for i  in 0..<monthArray.count {
                
                let month = monthArray[i]
                let numString = paramsDict[month.lowercased()]!
                let lineView = lineViewArray[Int(numString)!]
                lineView.isHidden = false
                
            }
            
        }
        
    }
    // Color setting
    var lineCorlor : UIColor = UIColor(){
        didSet{
            for i  in 0..<12 {
                let lineView = lineViewArray[i]
                lineView.backgroundColor = lineCorlor
            }
        }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSub()
    }
    func addSub() -> (){//60
        self.backgroundColor = UIColor.white
        // header line
        let lineW : CGFloat = screenW / 12.0
        let lineH : CGFloat = 5.0
        for i  in 0..<12 {
            let lineView = UIView()
            lineView.frame = CGRect.init(x: lineW * CGFloat(i) , y: 2, width: lineW, height: lineH)
            lineView.backgroundColor = UIColor.green
            self.contentView.addSubview(lineView)
            lineViewArray.append(lineView)
        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

