//
//  SQUChartViewController.swift
//  foursigma
//
//  Created by 姚逸晨 on 5/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import Charts

class SQUChartViewController: UIViewController {
    
    var squRecord = [String]()
    var squDouble = [Double]()
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Trend"
        
        changeList()
        setInstallationChart()
    }
    
    func changeList() {
        
        let tmp = ((squRecord[0] as NSString).doubleValue) / 204
        squDouble.append(tmp)
        for i in 1...squRecord.count - 1{
            let element = (squRecord[i] as NSString).doubleValue
            squDouble.append(element)
        }
    }
    
    func setInstallationChart() {
        
        let formato:BarChartFormatter = BarChartFormatter()
        let xaxis:XAxis = XAxis()
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0...self.squDouble.count - 1 {
            let dataEntry = BarChartDataEntry(x: Double(i), y: squDouble[i])
            dataEntries.append(dataEntry)
            formato.stringForValue(Double(i), axis: xaxis)
        }
        
        xaxis.valueFormatter = formato
        barChartView.xAxis.valueFormatter = xaxis.valueFormatter
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Electricity generated")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        barChartView.data = chartData
    }

}
