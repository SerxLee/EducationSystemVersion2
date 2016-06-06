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
    
    var search: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView.init()
        semesterOK.afterChange += {old, new in
            self.allSemesters = cacheSemester[self.type] as! [String]
            self.semesterNums = cacheSemesterNum[self.type] as! Int
            self.dataSourse = cacheCourseData[self.type] as! NSMutableDictionary
            self.tableView.reloadData()
        }
        
        searchFinished.afterChange += { old, new
            in
            if new == 2 {
                self.search = true
                self.tableView.reloadData()
                searchFinished <- 0
            }
            else if new == 22 {
                self.search = false
                self.tableView.reloadData()
                searchFinished <- 0
            }
        }
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
}



extension SemesterViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let indexOfSection = indexPath.section
        var stringOfSection: String!
        stringOfSection = allSemesters[indexOfSection]
        let limaa = cacheCourseData[type]!
        dict = (limaa[stringOfSection]! as! NSArray)[row] as? NSDictionary
        
        //deSelected the cell while it is the didSelected statue
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {

        let y = scrollView.contentOffset.y
        let offsetY:CGFloat = y
        if offsetY > NAVBAR_CHANGE_POINT {
            keyBoardHideWhileSlideTableView <- Float(offsetY)
        }
    }
}

extension SemesterViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if search {
            return 1
        }
        return self.semesterNums
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if search {
            return nil
        }
        return self.allSemesters[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if search {
            return searchResults.count
        }
        return self.dataSourse[allSemesters[section]]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier: String = "myCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! PageTVCell
        let row = indexPath.row
        let indexOfSection = indexPath.section
        var stringOfSection: String!
        let currentSectionCourse: [Dictionary<String, String>]!
        
        if search {
            currentSectionCourse = searchResults
        }
        else {
            stringOfSection = allSemesters[indexOfSection]
            currentSectionCourse = dataSourse[stringOfSection] as! [Dictionary<String, String>]
        }
        cell.courseName.text = currentSectionCourse[row]["name"]! as String
        cell.courseScore.text = currentSectionCourse[row]["score"]! as String
        return cell
    }
}