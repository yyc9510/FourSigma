//
//  LineChartFormatter6.swift
//  EcoLife
//
//  Created by 姚逸晨 on 9/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import Charts
import Foundation

@objc(LineChartFormatter6)

public class LineChartFormatter6: NSObject, IAxisValueFormatter {
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value)]!
    }
    
    let months: [String?] = ["2018 Oct", "2018 Nov", "2018 Dec"]
    
}
