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
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPassingView()
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

let NAVBAR_CHANGE_POINT: CGFloat = 0.0

extension PassingViewController: UITableViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let minHeight: CGFloat = (MasterViewController.getUIScreenSize(false) / 5.0)
        let rawHeight: CGFloat = (MasterViewController.getUIScreenSize(false) / 3.0)
        let maxCha: CGFloat = rawHeight - minHeight
        let color: UIColor = UIColor(red: 0/255, green: 175/255, blue: 240/255, alpha: 1)
        let y = scrollView.contentOffset.y
        let offsetY:CGFloat = y
//        print(offsetY)
        if offsetY > NAVBAR_CHANGE_POINT {
            height <- offsetY
            let alpha:CGFloat = 1.0 - ((maxCha - offsetY) / maxCha)
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
//            lim = scrollView.contentOffset.y
        }
        else {
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
        }
        if offsetY < 0.0 {
            
        }
    }
}

extension PassingViewController: UITableViewDataSource {
    
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