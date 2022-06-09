//
//  WeightTrackViewController.swift
//  Calo Track
//
//  Created by Sushen Satturu on 6/6/2022.
//

import UIKit
import Charts
import TinyConstraints
import FirebaseFirestore


class ChartValueFormatter: NSObject, IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        // https://stackoverflow.com/questions/40648284/using-dateformatter-on-a-unix-timestamp
        let date = Date(timeIntervalSince1970: value)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "AEST")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date)
    }
}


class WeightTrackViewController: UIViewController, ChartViewDelegate, DatabaseListener {
    var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .weight
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemBlue
        chartView.rightAxis.enabled = false
        
        
        // Set up yAxis
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .outsideChart
        
        // Set up xAxis
        let xAxis = chartView.xAxis
        xAxis.valueFormatter = ChartValueFormatter()
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .boldSystemFont(ofSize: 12)
        xAxis.setLabelCount(4, force: false)
        xAxis.labelTextColor = .white
        xAxis.axisLineColor = .systemBlue
        
        
        chartView.animate(xAxisDuration: 2.0)
        
        
        return chartView
    }()
    var weightList: [[String: Any]] = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        // Add chart to view
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        databaseController?.addListener(listener: self)
    }
    
    // MARK: - chart methods
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData(_ data: [ChartDataEntry]) {
        let set1 = LineChartDataSet(entries: data, label: "Weight")
        
        set1.circleRadius = CGFloat(4.0)
        set1.lineWidth = 2
        set1.setColor(.white)
        set1.fill = Fill(color: .white)
        
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
    
    // MARK: - methods
    func convertWeighListToChartData() {
        print(weightList)
        var chartData: [ChartDataEntry] = [ChartDataEntry]()
        
        for weightData in weightList {
            let weightAmount = weightData["weight"] as! Double
            let timestamp = weightData["date"] as! Timestamp
            let data = ChartDataEntry(x: Double(timestamp.seconds) , y: weightAmount)
            chartData.append(data)
        }
        
        setData(chartData)
    }
    
    // TODO - temp method remove when view connected to authentication and put in viewDidAppear
    @IBAction func getChartData(_ sender: Any) {
        databaseController?.getWeightsForUser()
    }
    
    
    
    // MARK: - listeners
    func onUserChange(change: DatabaseChange) {
        // Do nothing
    }
    
    func onFoodListChange(change: DatabaseChange, foodList: [[String : Any]]) {
        // Do nothing
    }
    
    func onWeightListChange(change: DatabaseChange, weightList: [[String : Any]]) {
        self.weightList = weightList
        convertWeighListToChartData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
