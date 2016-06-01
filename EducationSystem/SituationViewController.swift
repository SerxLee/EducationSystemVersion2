//
//  SituationViewController.swift
//  EducationSystem
//
//  Created by Serx on 16/5/26.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit
import Charts
import Observable

var startLoadChart: Observable<Int> = Observable(0)

class SituationViewController: UIViewController {
    
    var userName: String!
    var passWord: String!

    @IBOutlet weak var greditTotle: UILabel!
    @IBOutlet weak var scoreTotle: UILabel!
    @IBOutlet weak var specalGreditLabel: UILabel!
    @IBOutlet weak var netGreditLabel: UILabel!
    @IBOutlet weak var gpaLabel: UILabel!
    @IBOutlet weak var gpa4Label: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var scoreLineChartView: LineChartView!
    @IBOutlet weak var gpaLineChartView: LineChartView!
    
    @IBOutlet weak var lableContrainer00: NSLayoutConstraint!
    @IBOutlet weak var lableContrainer20: NSLayoutConstraint!
    @IBOutlet weak var lableContrainer21: NSLayoutConstraint!
    @IBOutlet weak var lableContrainer01: NSLayoutConstraint!
    
    @IBOutlet weak var scoreContrainer00: NSLayoutConstraint!
    @IBOutlet weak var scoreContrainer01: NSLayoutConstraint!
    @IBOutlet weak var scoreContrainer21: NSLayoutConstraint!
    @IBOutlet weak var scoreContrainer20: NSLayoutConstraint!
    
    @IBOutlet weak var topContrainer00: NSLayoutConstraint!
    @IBOutlet weak var topContrainer10: NSLayoutConstraint!
    @IBOutlet weak var topContrainer20: NSLayoutConstraint!
    @IBOutlet weak var topContrainer01: NSLayoutConstraint!
    @IBOutlet weak var topContrainer11: NSLayoutConstraint!
    @IBOutlet weak var topContrainer21: NSLayoutConstraint!
    
    @IBOutlet weak var lineLeftContrainer: NSLayoutConstraint!
    @IBOutlet weak var line2RightContrainer: NSLayoutConstraint!
    let semesters2 = ["S1", "S2", "S3", "S4", "S5", "S6", "S7", "S8"]
    let years = ["Year1", "Year2", "Year3", "Year4"]
    
    var classViewModel: SituationViewModel!
    lazy var logicManager: SituationLogicManager = {return SituationLogicManager()}()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        self.classViewModel = self.logicManager.classViewModel
        super.viewDidLoad()
        self.initView()
//        let aa = self.logicManager.calculation()
    }
    
    func initView() {
//        self.classViewModel.userName = self.userName
//        self.classViewModel.passWord = self.passWord
        self.view.backgroundColor = themeColor
        self.mainView.layer.cornerRadius = 10.0
        
        let lenghtToEdge: CGFloat = MasterViewController.getUIScreenSize(true) / 10.0
        self.setEdgeContrainer(lenghtToEdge)
        
//
//        NSLog("gpa")
//        print(self.classViewModel.gpaTerm)
//        NSLog("gpa4")
//        print(self.classViewModel.gpaTerm4)
//        NSLog("学期平均")
//        print(self.classViewModel.scoreTerm)
//        NSLog("平均成绩")
//        print(self.classViewModel.scoreAverage)
//        NSLog("必修学分")
//        print(self.classViewModel.creditSpecialized)
//        NSLog("选修学分")
//        print(self.classViewModel.creditPublic)
//        NSLog("网络学分")
//        print(self.classViewModel.creditNetwork)
//        NSLog("network")
//        print(self.classViewModel.courseDataNetwork)
//        NSLog("specialized")
//        print(self.classViewModel.courseDataSpecialized)
//        NSLog("public")
//        print(self.classViewModel.courseDataPublic)
//        print(self.classViewModel.allSemesters)
        
        startLoadChart.afterChange += { old, new in
            if new == 1 {
                self.setFirstChart(self.getCharTitle(true, numOfTitle: self.classViewModel.scoreTerm.count), values: self.classViewModel.scoreTerm)
                self.setSecondChart(self.getCharTitle(false, numOfTitle: self.classViewModel.gpaTerm.count), values: self.classViewModel.gpaTerm)
            }
        }
    }
    
    func setFirstChart(dataPoints: [String], values: [Double]) {
        //set the line chart
        self.scoreLineChartView.backgroundColor = UIColor.clearColor()
        self.scoreLineChartView.descriptionText = "学期平均分"
        self.scoreLineChartView.setVisibleXRangeMaximum(8)
        self.scoreLineChartView.rightAxis.enabled = false
        self.scoreLineChartView.xAxis.drawGridLinesEnabled = false
        self.scoreLineChartView.legend.enabled = false
        self.scoreLineChartView.scaleYEnabled = false
        self.scoreLineChartView.scaleXEnabled = false
        self.scoreLineChartView.pinchZoomEnabled = false
        self.scoreLineChartView.doubleTapToZoomEnabled = false
        self.scoreLineChartView.highlighter = nil
        let Left = self.scoreLineChartView.getAxis(ChartYAxis.AxisDependency.Left)
        self.scoreLineChartView.animate(xAxisDuration: 1.5, easingOption: .EaseInOutBack)

        
        Left.axisMinValue = 0.0
        Left.axisMaxValue = 100.0
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<values.count {
            let dataEntry = ChartDataEntry(value: values[i].double1, xIndex: i)
            dataEntries.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Units Sold")
        lineChartDataSet.circleColors = [themeColor]
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        self.scoreLineChartView.data = lineChartData
    }
    
    func setSecondChart(dataPoints: [String], values: [Double]) {
        //set the second line chart
        self.gpaLineChartView.backgroundColor = UIColor.clearColor()
        self.gpaLineChartView.descriptionText = "学年平均学分绩点(GPA)"
        self.gpaLineChartView.setVisibleXRangeMaximum(4)
        self.gpaLineChartView.rightAxis.enabled = false
        self.gpaLineChartView.xAxis.drawGridLinesEnabled = false
        self.gpaLineChartView.legend.enabled = false
        self.gpaLineChartView.scaleYEnabled = false
        self.gpaLineChartView.scaleXEnabled = false
        self.gpaLineChartView.pinchZoomEnabled = false
        self.gpaLineChartView.doubleTapToZoomEnabled = false
        self.gpaLineChartView.highlighter = nil
        let Left2 = self.gpaLineChartView.getAxis(ChartYAxis.AxisDependency.Left)
        self.gpaLineChartView.animate(xAxisDuration: 1.5, easingOption: .EaseInOutBack)

        Left2.axisMinValue = 0.0
        Left2.axisMaxValue = 5.0
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<values.count {
            let dataEntry = ChartDataEntry(value: values[i].double2, xIndex: i)
            dataEntries.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Units Sold")
        lineChartDataSet.circleColors = [themeColor]
        
        
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        self.gpaLineChartView.data = lineChartData
    }
    
    func getCharTitle(isFirst: Bool, numOfTitle: Int) -> [String]{
        var titles: [String] = []
        if isFirst {
            for i in 0 ..< numOfTitle {
                let title = "S" + "\(i + 1)"
                titles.append(title)
            }
        }
        else {
            for i in 0 ..< numOfTitle {
                let title = "Yr" + "\(i + 1)"
                titles.append(title)
            }
        }
        return titles
    }
    
    func setEdgeContrainer(lenght: CGFloat) {
        self.lableContrainer00.constant = lenght
        self.lableContrainer01.constant = lenght
        self.lableContrainer20.constant = lenght
        self.lableContrainer21.constant = lenght
        
        let lenght2 = lenght + 9.0
        self.scoreContrainer00.constant = lenght2
        self.scoreContrainer01.constant = lenght2
        self.scoreContrainer20.constant = lenght2
        self.scoreContrainer21.constant = lenght2
        
        let len = self.gpaLabel.superview!.bounds.size.height / 6.0
        self.topContrainer00.constant = len
        self.topContrainer01.constant = len
        self.topContrainer10.constant = len
        self.topContrainer11.constant = len
        self.topContrainer20.constant = len
        self.topContrainer21.constant = len
        
        let len2 = lenght
        self.line2RightContrainer.constant = len2
        self.lineLeftContrainer.constant = len2
        
        self.scoreTotle.text = String(Double(self.classViewModel.scoreAverage).double2)
        self.greditTotle.text = String(Double(self.classViewModel.creditPublic + self.classViewModel.creditNetwork + self.classViewModel.creditSpecialized).double2)
        self.specalGreditLabel.text = String(Double(self.classViewModel.creditSpecialized).double2)
        self.netGreditLabel.text = String(Double(self.classViewModel.creditNetwork).double2)
        self.gpa4Label.text = String(self.classViewModel.gpa4.double2)
        self.gpaLabel.text = String(self.classViewModel.gpa.double2)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
