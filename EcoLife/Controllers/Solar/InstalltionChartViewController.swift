//
//  InstalltionChartViewController.swift
//  foursigma
//
//  Created by 姚逸晨 on 5/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import Charts
import SkyFloatingLabelTextField

class InstalltionChartViewController: UIViewController {
    
    
    var installationRecord = [String]()
    var installationDouble = [Double]()
    var squRecord = [String]()
    var squDouble = [Double]()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lineChartView: LineChartView!
    
    let dataSourcePickData = ["Solar PVs Installations", "Electricity Produced by Solar PVs"]
    let timePeriodPickData = ["Year 2018", "Last Half Year 2018", "The First Quarter 2018", "The Second Quarter 2018", "The Third Quarter 2018", "The Fourth Quarter 2018"]
    
    var dataSourceText = SkyFloatingLabelTextField()
    var timePeriodText = SkyFloatingLabelTextField()
    
    @IBAction func showBarButton(_ sender: Any) {
        //lineChartView?.removeFromSuperview()
        generateLineGraph(dataSource: dataSourceText.text!, timePeriod: timePeriodText.text!)
    }
    
    func setUpLabel() {
        
        dataSourceText = SkyFloatingLabelTextField(frame: CGRect(x: 20, y: 120, width: 330, height: 40))
        timePeriodText = SkyFloatingLabelTextField(frame: CGRect(x: 20, y: 185, width: 330, height: 40))
        
        dataSourceText.placeholder = "E.g. Solar PVs Installations"
        dataSourceText.title = "Data Source"
        dataSourceText.tintColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        dataSourceText.selectedTitleColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        dataSourceText.selectedLineColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        
        self.scrollView.addSubview(dataSourceText)
        
        timePeriodText.placeholder = "E.g. Year 2018"
        timePeriodText.title = "Time Period"
        timePeriodText.tintColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        timePeriodText.selectedTitleColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        timePeriodText.selectedLineColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        
        self.scrollView.addSubview(timePeriodText)
        
        
    }
    
    let goBackButton: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.lightGray
        btn.setImage(UIImage(named: "go_back.png"), for: .normal)
        
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor=UIColor.gray
        btn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.01)
        
        setUpLabel()
        createDataSourcePicker()
        createTimePeriodPicker()
        createToolBar()
        handleDataSet()
        
        setInitLineChart()
        
        self.dataSourceText.text = "Solar PVs Installations"
        self.timePeriodText.text = "Year 2018"
        
        self.scrollView.addSubview(goBackButton)
        goBackButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive=true
        goBackButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive=true
        goBackButton.widthAnchor.constraint(equalToConstant: 50).isActive=true
        goBackButton.heightAnchor.constraint(equalTo: goBackButton.widthAnchor).isActive=true
        self.view.addSubview(scrollView)
    }
    
    @objc func goBack() {
        
        guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "Main") as? CustomTabBarController else { return }
        self.present(popupVC, animated:true, completion:nil)
    }
    
    func createDataSourcePicker() {
        let dataSourcePicker = UIPickerView()
        dataSourcePicker.delegate = self
        dataSourcePicker.tag = 1
        dataSourceText.inputView = dataSourcePicker
        dataSourcePicker.backgroundColor = .white
    }
    
    func createTimePeriodPicker() {
        let timePeriodPicker = UIPickerView()
        timePeriodPicker.delegate = self
        timePeriodPicker.tag = 2
        timePeriodText.inputView = timePeriodPicker
        timePeriodPicker.backgroundColor = .white
    }
    
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(InstalltionChartViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        dataSourceText.inputAccessoryView = toolBar
        timePeriodText.inputAccessoryView = toolBar
    }
    
    func handleDataSet() {
        for i in 0...installationRecord.count - 1 {
            self.installationDouble.append((installationRecord[i] as NSString).doubleValue)
        }
        for i in 0...squRecord.count - 1 {
            self.squDouble.append((squRecord[i] as NSString).doubleValue)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setInitLineChart() {
        
        let formato:LineChartFormatter1 = LineChartFormatter1()
        let xaxis:XAxis = XAxis()
        
        var lineChartEntry = [ChartDataEntry]()
        
        for i in 0...installationRecord.count - 1 {
            let value = ChartDataEntry(x: Double(i), y: installationDouble[i])
            lineChartEntry.append(value)
            formato.stringForValue(Double(i), axis: xaxis)
        }
        
        xaxis.valueFormatter = formato
        lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
        
        let chartDataSet = LineChartDataSet(values: lineChartEntry, label: "Number of Solar PV Installation")
        let chartData = LineChartData()
        chartData.addDataSet(chartDataSet)
        lineChartView.data = chartData
    }
    
    func generateLineGraph(dataSource: String, timePeriod: String) {
        
        if dataSource == "Solar PVs Installations" {
            
            if timePeriod == "Year 2018" {
            
                let formato:LineChartFormatter1 = LineChartFormatter1()
                let xaxis:XAxis = XAxis()
                
                var lineChartEntry = [ChartDataEntry]()
                
                for i in 0...11 {
                    let value = ChartDataEntry(x: Double(i), y: installationDouble[i])
                    lineChartEntry.append(value)
                    formato.stringForValue(Double(i), axis: xaxis)
                }
                
                xaxis.valueFormatter = formato
                lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
                
                let chartDataSet = LineChartDataSet(values: lineChartEntry, label: "Number of Solar PV Installation")
                let chartData = LineChartData()
                chartData.addDataSet(chartDataSet)
                lineChartView.data = chartData
                
            }
            
            else if timePeriod == "Last Half Year 2018" {
                
                let formato:LineChartFormatter2 = LineChartFormatter2()
                let xaxis:XAxis = XAxis()
                
                var lineChartEntry = [ChartDataEntry]()
                
                for i in 0...5 {
                    let value = ChartDataEntry(x: Double(i), y: installationDouble[i + 6])
                    lineChartEntry.append(value)
                    formato.stringForValue(Double(i), axis: xaxis)
                }
                
                xaxis.valueFormatter = formato
                lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
                
                let chartDataSet = LineChartDataSet(values: lineChartEntry, label: "Number of Solar PV Installation")
                let chartData = LineChartData()
                chartData.addDataSet(chartDataSet)
                lineChartView.data = chartData
            }
            
            else if timePeriod == "Electricity Produced by Solar PVs" {
                
                let formato:LineChartFormatter3 = LineChartFormatter3()
                let xaxis:XAxis = XAxis()
                
                var lineChartEntry = [ChartDataEntry]()
                
                for i in 0...2 {
                    let value = ChartDataEntry(x: Double(i), y: installationDouble[i])
                    lineChartEntry.append(value)
                    formato.stringForValue(Double(i), axis: xaxis)
                }
                
                xaxis.valueFormatter = formato
                lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
                
                let chartDataSet = LineChartDataSet(values: lineChartEntry, label: "Number of Solar PV Installation")
                let chartData = LineChartData()
                chartData.addDataSet(chartDataSet)
                lineChartView.data = chartData
            }
            
            if timePeriod == "The Second Quarter 2018" {
                
                let formato:LineChartFormatter4 = LineChartFormatter4()
                let xaxis:XAxis = XAxis()
                
                var lineChartEntry = [ChartDataEntry]()
                
                for i in 0...2 {
                    let value = ChartDataEntry(x: Double(i), y: installationDouble[i + 3])
                    lineChartEntry.append(value)
                    formato.stringForValue(Double(i), axis: xaxis)
                }
                
                xaxis.valueFormatter = formato
                lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
                
                let chartDataSet = LineChartDataSet(values: lineChartEntry, label: "Number of Solar PV Installation")
                let chartData = LineChartData()
                chartData.addDataSet(chartDataSet)
                lineChartView.data = chartData
            }
            
            else if timePeriod == "The Third Quarter 2018" {
                
                let formato:LineChartFormatter5 = LineChartFormatter5()
                let xaxis:XAxis = XAxis()
                
                var lineChartEntry = [ChartDataEntry]()
                
                for i in 0...2 {
                    let value = ChartDataEntry(x: Double(i), y: installationDouble[i + 6])
                    lineChartEntry.append(value)
                    formato.stringForValue(Double(i), axis: xaxis)
                }
                
                xaxis.valueFormatter = formato
                lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
                
                let chartDataSet = LineChartDataSet(values: lineChartEntry, label: "Number of Solar PV Installation")
                let chartData = LineChartData()
                chartData.addDataSet(chartDataSet)
                lineChartView.data = chartData
            }
            
            else if timePeriod == "The Fourth Quarter 2018" {
                
                let formato:LineChartFormatter6 = LineChartFormatter6()
                let xaxis:XAxis = XAxis()
                
                var lineChartEntry = [ChartDataEntry]()
                
                for i in 0...2 {
                    let value = ChartDataEntry(x: Double(i), y: installationDouble[i + 9])
                    lineChartEntry.append(value)
                    formato.stringForValue(Double(i), axis: xaxis)
                }
                
                xaxis.valueFormatter = formato
                lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
                
                let chartDataSet = LineChartDataSet(values: lineChartEntry, label: "Number of Solar PV Installation")
                let chartData = LineChartData()
                chartData.addDataSet(chartDataSet)
                lineChartView.data = chartData
            }
        }
        
        else if dataSource == "Electricity Produced by Solar PVs" {
            
            if timePeriod == "Year 2018" {
                
                let formato:LineChartFormatter1 = LineChartFormatter1()
                let xaxis:XAxis = XAxis()
                
                var lineChartEntry = [ChartDataEntry]()
                
                for i in 0...11 {
                    let value = ChartDataEntry(x: Double(i), y: squDouble[i])
                    lineChartEntry.append(value)
                    formato.stringForValue(Double(i), axis: xaxis)
                }
                
                xaxis.valueFormatter = formato
                lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
                
                let chartDataSet = LineChartDataSet(values: lineChartEntry, label: "Electricity Produced by Solar PVs")
                let chartData = LineChartData()
                chartData.addDataSet(chartDataSet)
                lineChartView.data = chartData
                
            }
                
            else if timePeriod == "Last Half Year 2018" {
                
                let formato:LineChartFormatter2 = LineChartFormatter2()
                let xaxis:XAxis = XAxis()
                
                var lineChartEntry = [ChartDataEntry]()
                
                for i in 0...5 {
                    let value = ChartDataEntry(x: Double(i), y: squDouble[i + 6])
                    lineChartEntry.append(value)
                    formato.stringForValue(Double(i), axis: xaxis)
                }
                
                xaxis.valueFormatter = formato
                lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
                
                let chartDataSet = LineChartDataSet(values: lineChartEntry, label: "Electricity Produced by Solar PVs")
                let chartData = LineChartData()
                chartData.addDataSet(chartDataSet)
                lineChartView.data = chartData
            }
                
            else if timePeriod == "The First Quarter 2018" {
                
                let formato:LineChartFormatter3 = LineChartFormatter3()
                let xaxis:XAxis = XAxis()
                
                var lineChartEntry = [ChartDataEntry]()
                
                for i in 0...2 {
                    let value = ChartDataEntry(x: Double(i), y: squDouble[i])
                    lineChartEntry.append(value)
                    formato.stringForValue(Double(i), axis: xaxis)
                }
                
                xaxis.valueFormatter = formato
                lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
                
                let chartDataSet = LineChartDataSet(values: lineChartEntry, label: "Electricity Produced by Solar PVs")
                let chartData = LineChartData()
                chartData.addDataSet(chartDataSet)
                lineChartView.data = chartData
            }
            
            if timePeriod == "The Second Quarter 2018" {
                
                let formato:LineChartFormatter4 = LineChartFormatter4()
                let xaxis:XAxis = XAxis()
                
                var lineChartEntry = [ChartDataEntry]()
                
                for i in 0...2 {
                    let value = ChartDataEntry(x: Double(i), y: squDouble[i + 3])
                    lineChartEntry.append(value)
                    formato.stringForValue(Double(i), axis: xaxis)
                }
                
                xaxis.valueFormatter = formato
                lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
                
                let chartDataSet = LineChartDataSet(values: lineChartEntry, label: "Electricity Produced by Solar PVs")
                let chartData = LineChartData()
                chartData.addDataSet(chartDataSet)
                lineChartView.data = chartData
            }
                
            else if timePeriod == "The Third Quarter 2018" {
                
                let formato:LineChartFormatter5 = LineChartFormatter5()
                let xaxis:XAxis = XAxis()
                
                var lineChartEntry = [ChartDataEntry]()
                
                for i in 0...2 {
                    let value = ChartDataEntry(x: Double(i), y: squDouble[i + 6])
                    lineChartEntry.append(value)
                    formato.stringForValue(Double(i), axis: xaxis)
                }
                
                xaxis.valueFormatter = formato
                lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
                
                let chartDataSet = LineChartDataSet(values: lineChartEntry, label: "Electricity Produced by Solar PVs")
                let chartData = LineChartData()
                chartData.addDataSet(chartDataSet)
                lineChartView.data = chartData
            }
                
            else if timePeriod == "The Fourth Quarter 2018" {
                
                let formato:LineChartFormatter6 = LineChartFormatter6()
                let xaxis:XAxis = XAxis()
                
                var lineChartEntry = [ChartDataEntry]()
                
                for i in 0...2 {
                    let value = ChartDataEntry(x: Double(i), y: squDouble[i + 9])
                    lineChartEntry.append(value)
                    formato.stringForValue(Double(i), axis: xaxis)
                }
                
                xaxis.valueFormatter = formato
                lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
                
                let chartDataSet = LineChartDataSet(values: lineChartEntry, label: "Electricity Produced by Solar PVs")
                let chartData = LineChartData()
                chartData.addDataSet(chartDataSet)
                lineChartView.data = chartData
            }
        }
    }
}

extension InstalltionChartViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return dataSourcePickData.count
        }
        else {
            return timePeriodPickData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return "\(dataSourcePickData[row])"
        }
        else {
            return "\(timePeriodPickData[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            dataSourceText.text = dataSourcePickData[row]
        }
        else {
            timePeriodText.text = timePeriodPickData[row]
        }
    }
}
