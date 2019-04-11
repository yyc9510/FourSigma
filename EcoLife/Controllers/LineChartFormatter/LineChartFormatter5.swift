//
//  LineChartFormatter5.swift
//  EcoLife
//
//  Created by 姚逸晨 on 9/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import Charts
import Foundation

@objc(LineChartFormatter5)

public class LineChartFormatter5: NSObject, IAxisValueFormatter {
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value)]!
    }
    
    let months: [String?] = ["2018 Jul", "2018 Aug", "2018 Sep"]
    
}