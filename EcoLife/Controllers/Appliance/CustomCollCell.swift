//
//  CustomCollCell.swift
//  EcoLife
//
//  Created by 姚逸晨 on 7/5/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit

class CustomCollCell: UICollectionViewCell {
    let containView = UIView()
    let icon = UIImageView()
    let titleLab = UILabel()
    let operationBtn = UIButton.init(type: .custom)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSub()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSub() -> (){
        // 207  103.5
        //let itemW = NEWFITSCALEX(414/2.0)
        //self.contentView.backgroundColor = UIColor.gray
        
        containView.frame = CGRect.init(x: NEWFITSCALEX(20), y: NEWFITSCALEX(5), width: NEWFITSCALEX(177), height: NEWFITSCALEX(93.5))
        //containView.backgroundColor = UIColor.red
        self.contentView.addSubview(containView)
        containView.layer.cornerRadius = 5
        
        //1
        
        // width, height: 24
        icon.frame = CGRect.init(x: NEWFITSCALEX(15), y: NEWFITSCALEX(10), width: NEWFITSCALEX(36), height: NEWFITSCALEX(36))
        containView.addSubview(icon)
        
        
        //2 operation
        
        operationBtn.frame = CGRect.init(x: NEWFITSCALEX(140), y: NEWFITSCALEX(10), width: NEWFITSCALEX(24), height: NEWFITSCALEX(24))
        //operationBtn.setImage(UIImage(named: "Group Copy 8"), for: .normal)
        operationBtn.setTitle("...", for: .normal)
        operationBtn.titleLabel?.font = UIFont.systemFont(ofSize: 27)
        operationBtn.titleEdgeInsets = UIEdgeInsets.init(top: NEWFITSCALEX(-14), left: 0, bottom: 0, right: 0)
        containView.addSubview(operationBtn)
        operationBtn.backgroundColor = MASK_BACkGROUND_COLOR.withAlphaComponent(0.2)
        operationBtn.layer.cornerRadius = NEWFITSCALEX(12)
        //3 title
        
        titleLab.frame = CGRect.init(x: NEWFITSCALEX(15), y: NEWFITSCALEX(60), width: NEWFITSCALEX(137), height: NEWFITSCALEX(33))
        titleLab.textAlignment = NSTextAlignment.left
        titleLab.text = ""
        titleLab.numberOfLines = 2
        titleLab.textColor = UIColor.white
        titleLab.font = UIFont.boldSystemFont(ofSize: 15)
        //titleLab.sizeToFit()
        containView.addSubview(titleLab)
    }
}

