//
//  Appliance.swift
//  EcoLife
//
//  Created by 姚逸晨 on 5/5/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import Foundation
import UIKit

struct Appliance {
    
    var brand: Brand
    var model: Model
    var manufacturer: String
    var energyConsumption: String
    var rating: String
    var type: String
    
    var size: String
    var ecoRating : String
    
    var backColor : String
    var icon : UIImage
}

struct Brand {
    
    var name: String
    var isSelected: Bool
    
}

struct Model {
    
    var name: String
    var isSelected: Bool
    
}

struct ExpandableSection {
    
    var isExpanded: Bool
    var modelList: [Model]
}
