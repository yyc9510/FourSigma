//
//  LineChartFormatter4.swift
//  EcoLife
//
//  Created by 姚逸晨 on 9/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import Charts
import Foundation

@objc(LineChartFormatter4)

public class LineChartFormatter4: NSObject, IAxisValueFormatter {
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value)]!
    }
    
    let months: [String?] = ["2018 Apr", "2018 May", "2018 Jun"]
    
}
