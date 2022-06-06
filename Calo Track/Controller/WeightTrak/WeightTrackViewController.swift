//
//  WeightTrackViewController.swift
//  Calo Track
//
//  Created by Sushen Satturu on 6/6/2022.
//

import UIKit
import Charts
import TinyConstraints

class WeightTrackViewController: UIViewController, ChartViewDelegate {
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemBlue
        chartView.rightAxis.enabled = false
        
        
        return chartView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        
        setData()
        
    }
    
    // MARK: - chart methods
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData() {
        let set1 = LineChartDataSet(entries: chartData, label: "Weight")
        
        let data = LineChartData(dataSet: set1)
        lineChartView.data = data
    }
    
    let chartData: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 0.0),
        ChartDataEntry(x: 1.0, y: 1.0),
        ChartDataEntry(x: 2.0, y: 4.0),
        ChartDataEntry(x: 3.0, y: 9.0),
        ChartDataEntry(x: 4.0, y: 16.0),
        ChartDataEntry(x: 5.0, y: 25.0),
        ChartDataEntry(x: 6.0, y: 36.0),
        ChartDataEntry(x: 7.0, y: 49.0),
    ]
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
