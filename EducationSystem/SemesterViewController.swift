//
//  SemesterViewController.swift
//  EducationSystem
//
//  Created by Serx on 16/5/26.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit
import Observable

public var semesterOK: Observable<Bool> = Observable(false)

class SemesterViewController: UIViewController {

    private let type: String = "semester"
    var dataSourse: NSMutableDictionary = [:]
    var semesterNums: Int = 0
    var allSemesters: [String] = []
    @IBOutlet weak var tableView: UITableView!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        semesterOK.afterChange += {old, new in
            self.allSemesters = cacheSemester[self.type] as! [String]
            self.semesterNums = cacheSemesterNum[self.type] as! Int
            self.dataSourse = cacheCourseData[self.type] as! NSMutableDictionary
            self.tableView.reloadData()
//            NSLog("reload")
        }
        self.tableView.tableFooterView = UIView.init()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    var lim: CGFloat = 0.0
}



extension SemesterViewController: UITableViewDelegate {
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        let minHeight: CGFloat = (MasterViewController.getUIScreenSize(false) / 5.0)
//        let rawHeight: CGFloat = (MasterViewController.getUIScreenSize(false) / 3.0)
//        let maxCha: CGFloat = rawHeight - minHeight
//        let color: UIColor = UIColor(red: 0/255, green: 175/255, blue: 240/255, alpha: 1)
//        let y = scrollView.contentOffset.y - lim
//        let offsetY:CGFloat = y + height.value
//        print(offsetY)
//        if offsetY > NAVBAR_CHANGE_POINT {
//            height <- offsetY
//            let alpha:CGFloat = 1.0 - ((maxCha - offsetY) / maxCha)
//            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
//            lim = scrollView.contentOffset.y
//
//        }
//        else {
//            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
//        }
//        if offsetY < 0.0 {
//            
//        }
//    }
}

extension SemesterViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.semesterNums
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.allSemesters[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourse[allSemesters[section]]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier: String = "myCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell
        let row = indexPath.row
        let indexOfSection = indexPath.section
        var stringOfSection: String!
        
        stringOfSection = allSemesters[indexOfSection]
        let currentSectionCourse: [Dictionary<String, String>] = dataSourse[stringOfSection] as! [Dictionary<String, String>]
        
        cell.textLabel?.text = currentSectionCourse[row]["name"]! as String
        return cell
    }
}