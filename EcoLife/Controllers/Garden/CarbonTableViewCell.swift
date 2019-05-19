//
//  CarbonTableViewCell.swift
//  EcoLife
//
//  Created by 姚逸晨 on 19/5/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit

class CarbonTableViewCell: UITableViewCell {

    
    @IBOutlet weak var carbonImageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
