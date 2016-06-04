//
//  CourseDetailViewController.swift
//  EducationSystem
//
//  Created by Serx on 16/5/27.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit

var dict: NSDictionary!

class CourseDetailViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    lazy var logicManager: CourseDetailLogicManager = {return CourseDetailLogicManager()}()
    
    @IBOutlet weak var rightBarItem: UIBarButtonItem!
    @IBOutlet weak var leftBarItem: UIBarButtonItem!
    
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableVIewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableVIewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableVIewLeftConstraint: NSLayoutConstraint!
    
    var courseName: UILabel!
    
    let labelTitle = ["课程号", "学分", "成绩" , "类型", "原因"]
    var labelData : [String] = []
//    let lableDataLim = ["1702059", "2.5", "65", "必修", ""]
    
    var classViewModel: CourseDetailViewModel!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        labelData = [(dict["id"] as? String)!, (dict["credit"] as? String)!, (dict["score"] as? String)!, (dict["type"] as? String)!, (dict["not_pass_reason"] as? String)!]
        self.initView()
    }
    
    func initView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.clearColor()
        
        self.classViewModel = self.logicManager.classViewModel
        self.navigationController?.navigationBar.lt_setBackgroundColor(themeColor.colorWithAlphaComponent(0.0))
        self.navigationController?.navigationBar.hideBottomHairline()
        let img = UIImage(named: "shareImage")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.rightBarItem.image = img
        self.rightBarItem.style = .Plain
        
        let img2 = UIImage(named: "backImage")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.leftBarItem.image = img2
        self.leftBarItem.style = .Plain
        
        self.commentButton.backgroundColor = themeColor
        self.commentButton.layer.cornerRadius = 5.0

        self.setGradruallyBackground()
        self.setLabels()
    }
    
    func setGradruallyBackground() {
        //set two color
        let topColor = themeColor
        let buttomColor = UIColor.whiteColor()
        //pu the location and color into array
        let gradientColors: [CGColor] = [topColor.CGColor, buttomColor.CGColor]
        let gradientLocations: [CGFloat] = [0.0, 1.0]
        //create a CAGradientLayer object, and set the properties
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        //set the frame and insert the layer to super view
        gradientLayer.frame = CGRectMake(0, 0, MasterViewController.getUIScreenSize(true), MasterViewController.getUIScreenSize(false) / 3.0)
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    func setLabels() {
        
        
        let screenWidth: CGFloat = MasterViewController.getUIScreenSize(true)
        let screenHeight: CGFloat = MasterViewController.getUIScreenSize(false)
        
        let height1: CGFloat = screenHeight / 10
        let width1: CGFloat = screenWidth / 4.0
        let titleSize = (screenWidth - width1 * 2) / 9.0
        
        let rect1 = CGRectMake(width1, height1, screenWidth - 2*width1, titleSize*3)

        self.courseName = UILabel(frame: rect1)
        self.courseName.text = dict["name"] as? String
//        self.courseName.text = "前方高能前方高能前方前方高能前方高能高能前方高能"
        self.courseName.textColor = UIColor.whiteColor()
        self.courseName.textAlignment = .Center
        self.courseName.numberOfLines = 2
        self.courseName.font = UIFont.systemFontOfSize(titleSize)
        self.courseName.autoresizingMask = .FlexibleTopMargin
        self.view.addSubview(courseName)
        
        let width2 = screenWidth / 6.0
        let height2 = screenHeight / 3.0
        
        self.tableViewTopConstraint.constant = height2
        self.tableVIewBottomConstraint.constant = height2
        self.tableVIewLeftConstraint.constant = width2
        self.tableVIewRightConstraint.constant = width2
        
    }
    
    //turn back action
    @IBAction func leftBarItemAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func rightBarItemAction(sender: AnyObject) {
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "DetailToComment" {
            let next = segue.destinationViewController as! CommentViewController
//            let next = na.topViewController as! CommentViewController
            next.className = (dict!["id"] as? String)!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension CourseDetailViewController: UITableViewDelegate {
    
}

extension CourseDetailViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.labelData[4] == "" {
            return 4
        }
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return MasterViewController.getUIScreenSize(true) / 10.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier: String = "myCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! situationTVCell
        let row = indexPath.row
        cell.titleLabel.text = (self.labelTitle[row])
        cell.dataLabel.text = ": \(self.labelData[row])"
        return cell
        
    }
}
