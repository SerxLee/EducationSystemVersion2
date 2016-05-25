//
//  MainViewController.swift
//  EducationSystem
//
//  Created by Serx on 16/5/23.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit
import Foundation
import AFNetworking

class MainViewController: UIViewController {
    

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let type: String = "passing"
    
    var classViewModel: MainViewModel!
    lazy var logicManager: MainLogicManager = {
        return MainLogicManager()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMainViewController()
        myView.alpha = 0.5
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.lt_reset()
    }
    
    func initMainViewController() {
        self.classViewModel = self.logicManager.classViewModel
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}


let NAVBAR_CHANGE_POINT = 0.0 // Replace it by your value, keep it double

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let color: UIColor = UIColor(red: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)
        let offsetY = Double(scrollView.contentOffset.y)
//        NSLog("%f -> y", offsetY)
        if offsetY > NAVBAR_CHANGE_POINT {
            let alpha: CGFloat = CGFloat(min(1.0, 1.0 - ((NAVBAR_CHANGE_POINT + 64.0 - offsetY) / 64.0)))
//            NSLog("%f", alpha)
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
            
        } else {
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.logicManager.DataSourse[self.classViewModel.allSemesters[section]]!.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.classViewModel.allSemesters[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "myCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell
        let row = indexPath.row
        let section = indexPath.section
        var stringOfSection: String!
        stringOfSection = self.classViewModel.allSemesters[section]
        self.classViewModel.courseDataSourse = cacheCourseData[type]![stringOfSection]! as! [Dictionary<String, String>]
        cell.textLabel!.text = self.classViewModel.courseDataSourse[row]["name"]! as String
        return cell
    }
}