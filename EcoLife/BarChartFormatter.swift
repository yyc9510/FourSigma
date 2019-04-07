//
//  BarChartFormatter.swift
//  foursigma
//
//  Created by 姚逸晨 on 5/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import Charts
import Foundation

@objc(BarChartFormatter)

public class BarChartFormatter: NSObject, IAxisValueFormatter {
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value)]!
    }
    
    let months: [String?] = ["2001-2017", "2018 Jan", "2018 Feb", "2018 Mar", "2018 Apr", "2018 May"
    , "2018 Jun", "2018 Jul", "2018 Aug", "2018 Sep", "2018 Oct", "2018 Nov", "2018 Dec", "2019 Jan"
    , "2019 Feb"]
    
    
}
