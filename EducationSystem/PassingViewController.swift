//
//  PassingViewController.swift
//  EducationSystem
//
//  Created by Serx on 16/5/26.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit
import Observable

public let test: Bool = true
public var passingGetDataOK: Observable<Bool> = Observable(false)

class PassingViewController: UIViewController {
    
    private let type: String = "passing"
    var dataSourse: NSMutableDictionary!
    var semesterNums: Int!
    var allSemesters: [String]!
    
    var search: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = self.view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initPassingView()
        // Do any additional setup after loading the view.
    }
    
    func initPassingView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.allSemesters = cacheSemester[type] as! [String]
        self.semesterNums = cacheSemesterNum[type] as! Int
        self.dataSourse = cacheCourseData[type] as! NSMutableDictionary
        self.tableView.tableFooterView = UIView.init()
        self.tableView.reloadData()
        
        searchFinished.afterChange += { old, new
            in
            if new == 1 {
                self.search = true
                self.tableView.reloadData()
                searchFinished <- 0
            }
            else if new == 11 {
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
     */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//        if segue.identifier == "PassingToDetail" {
//            let nextController = segue.destinationViewController as! CourseDetailViewController
//        }
    }
}

let NAVBAR_CHANGE_POINT: CGFloat = 0.0

extension PassingViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        if search {
            dict = searchResults[row]
        }
        else {
            let indexOfSection = indexPath.section
            var stringOfSection: String!
            stringOfSection = allSemesters[indexOfSection]
            let limaa = cacheCourseData[type]!
            dict = (limaa[stringOfSection]! as! NSArray)[row] as? NSDictionary
        }
        
        //deSelected the cell while it is the didSelected statue
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
//        let minHeight: CGFloat = (MasterViewController.getUIScreenSize(false) / 5.0)
//        let rawHeight: CGFloat = (MasterViewController.getUIScreenSize(false) / 3.0)
//        let minHeight: CGFloat = 90.0
//        let maxCha: CGFloat = rawHeight - minHeight
//        let color: UIColor = UIColor(red: 0/255, green: 175/255, blue: 240/255, alpha: 1)
        let y = scrollView.contentOffset.y
        let offsetY:CGFloat = y
//        print(offsetY)
        if offsetY > NAVBAR_CHANGE_POINT {
            height <- offsetY
            keyBoardHideWhileSlideTableView <- Float(offsetY)
//            let alpha:CGFloat = 1.0 - ((maxCha - offsetY) / maxCha)
//            currentAlpha = alpha
//            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
//            lim = scrollView.contentOffset.y
        }
//        else {
//            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
//        }
//        if offsetY < 0.0 {
//            
//        }
    }
}

extension PassingViewController: UITableViewDataSource {
    
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