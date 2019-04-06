//
//  InstalltionChartViewController.swift
//  foursigma
//
//  Created by 姚逸晨 on 5/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import Charts

class InstalltionChartViewController: UIViewController {
    
    var installationRecord = [String]()
    var installationDouble = [Double]()
    
    @IBOutlet weak var barChartView: BarChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Trend"
        changeList()
        setInstallationChart()
    }
    
    func changeList() {
        let tmp = ((installationRecord[0] as NSString).doubleValue) / 204
        installationDouble.append(tmp)
        for i in 1...installationRecord.count - 1{
            let element = (installationRecord[i] as NSString).doubleValue
            installationDouble.append(element)
        }
    }
    
    func setInstallationChart() {
        
        let formato:BarChartFormatter = BarChartFormatter()
        let xaxis:XAxis = XAxis()
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0...self.installationRecord.count - 1 {
            let dataEntry = BarChartDataEntry(x: Double(i), y: installationDouble[i])
            dataEntries.append(dataEntry)
            formato.stringForValue(Double(i), axis: xaxis)
        }
        
        xaxis.valueFormatter = formato
        barChartView.xAxis.valueFormatter = xaxis.valueFormatter
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Number of Solar PV Installation")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        barChartView.data = chartData
    }
    


}
