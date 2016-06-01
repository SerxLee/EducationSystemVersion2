//
//  MasterViewController.swift
//  EducationSystem
//
//  Created by Serx on 16/5/25.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit
import Observable

let themeColor: UIColor = UIColor(red: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)

public var height: Observable<CGFloat> = Observable(0)
public var currentHeight: CGFloat = 0.0
public var limHeight: CGFloat = 0.0
public var currentAlpha: CGFloat = 0.0

class MasterViewController: UIViewController {
    
    var personalView: PersonSideBar!
    
    //situation container view
    @IBOutlet weak var situationContainer: UIView!
    
    @IBOutlet weak var titleBarSegment: UISegmentedControl!
    @IBOutlet weak var leftBarItem: UIBarButtonItem!
    @IBOutlet weak var rightBarItem: UIBarButtonItem!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var firstViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var passingButton: UIButton!
    @IBOutlet weak var semesterButton: UIButton!
    @IBOutlet weak var failButton: UIButton!
    
    //
    @IBOutlet weak var passingButtonToLeftBargin: NSLayoutConstraint!
    @IBOutlet weak var failButtonToRightBargin: NSLayoutConstraint!
    
    var type: String!
    var userName: String!
    var passWord: String!
    var rawHeight: CGFloat!
    var minHeight: CGFloat!
    
    var controlBarLenght: CGFloat = MasterViewController.getUIScreenSize(true) / 3.0
    var pageIndex: Int = 0
    
    var screenEdgeRecognizer: UIScreenEdgePanGestureRecognizer!
    var currentRadius:CGFloat = 0.0
    
    var masterPageViewController: MasterPageViewController? {
        didSet {
            masterPageViewController?.masterDelegate = self
        }
    }
    var classViewModel: MasterViewModel!
    
    var logicManager: MasterLogicManager = { return MasterLogicManager() }()
    
    var testLengh: CGFloat = 0.0

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    func initView() {
        let color: UIColor = UIColor(red: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)

        let img = UIImage(named: "search")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.rightBarItem.image = img
        self.rightBarItem.style = .Plain
        
        let img2 = UIImage(named: "menu")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.leftBarItem.image = img2
        self.leftBarItem.style = .Plain
        
        //set segmentControl's properties
        
        self.titleBarSegment.tintColor = UIColor.whiteColor() 
        
        self.classViewModel = self.logicManager.classViewModel
        self.type = "passing"
        self.classViewModel.userName = self.userName
        self.classViewModel.passWord = self.passWord
        
        //situation container view
        self.situationContainer.alpha = 0
        
        //side menu
        self.personalView = PersonSideBar.init(frame: self.view.frame)
        self.personalView.alpha = 0
        UIApplication.sharedApplication().keyWindow?.addSubview(self.personalView)
        
        self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.hideBottomHairline()
        
        self.rawHeight = (MasterViewController.getUIScreenSize(false) / 3.0)
//        self.minHeight = MasterViewController.getUIScreenSize(false) / 5.0
        self.minHeight = 90.0
        self.firstViewHeight.constant = rawHeight
        currentHeight = rawHeight
        height.afterChange += {old, new in
            self.testLengh = new
            self.changHeight()
        }
        
        self.screenEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.dragSideMenu(_:)))
        self.screenEdgeRecognizer.edges = .Left
        self.screenEdgeRecognizer.delegate = self
        self.view.addGestureRecognizer(screenEdgeRecognizer)
        
        self.passingButtonToLeftBargin.constant = (self.controlBarLenght - 71.0) / 2.0
        self.failButtonToRightBargin.constant = (self.controlBarLenght - 46) / 2.0
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.lt_reset()
    }
    
    func changHeight() {
        if currentHeight - self.testLengh <= minHeight {
            return
        }
        self.firstViewHeight.constant = currentHeight - self.testLengh
        limHeight = self.firstViewHeight.constant
    }
    @IBAction func showSideBar(sender: AnyObject) {
        showSideMenu()
    }
    
    func showSideMenu(){
        self.personalView.userKey = self.userName
        self.personalView.showPersonal()
    }
    func dragSideMenu(sender: UIScreenEdgePanGestureRecognizer){
        if sender.state == .Ended {
            self.personalView.dragSideBarEnd()
        }
        else if sender.state == .Began{
            self.personalView.userKey = self.userName
        }
        else {
            let dragPoint = sender.translationInView(self.view)
            self.personalView.showPersionalViaDrag(dragPoint)
        }
    }
    

    @IBAction func segmentAction(sender: UISegmentedControl) {
        let title = self.titleBarSegment.titleForSegmentAtIndex(self.titleBarSegment.selectedSegmentIndex)!
//        NSLog(title)
        if title == "学习情况" {
            UIView.animateWithDuration(0.2, animations: {
                self.situationContainer.alpha = 1.0
                self.navigationController?.navigationBar.lt_setBackgroundColor(themeColor.colorWithAlphaComponent(1.0))
            })
            startLoadChart <- 1
//            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SituationView")
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if title == "成绩总览" {
            UIView.animateWithDuration(0.2, animations: {
                self.situationContainer.alpha = 0
                self.navigationController?.navigationBar.lt_setBackgroundColor(themeColor.colorWithAlphaComponent(currentAlpha))
            })
            startLoadChart <- 0
        }
    }

    @IBAction func clickSemesterButton(sender: UIButton) {
        self.type = "semester"
        self.logicManager.checkCurrentTypeCourseIsExist(self.type)
        self.masterPageViewController?.scrollToViewController(index: 1)
    }
    @IBAction func clickPassingButton(sender: UIButton) {
        self.type = "passing"
        self.logicManager.checkCurrentTypeCourseIsExist(self.type)
        self.masterPageViewController?.scrollToViewController(index: 0)
    }
    @IBAction func clickFailButton(sender: UIButton) {
        self.type = "fail"
        self.logicManager.checkCurrentTypeCourseIsExist(self.type)
        self.masterPageViewController?.scrollToViewController(index: 2)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let masterPageViewController = segue.destinationViewController as? MasterPageViewController {
            self.masterPageViewController = masterPageViewController
        }
    }
    
    static func getUIScreenSize(isWidth: Bool) -> CGFloat{
        let iOSDeviceScreenSize: CGSize = UIScreen.mainScreen().bounds.size
        if isWidth {
            return iOSDeviceScreenSize.width
        }
        else {
            return iOSDeviceScreenSize.height
        }
    }
}

extension MasterViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension MasterViewController: MasterPageViewControllerDelegate {
    
    //page View ture to page and reload the table view
    func masterPageViewController(masterPageViewController: MasterPageViewController, didUpdatePageIndex index: Int) {
        self.logicManager.getDataAfterScroll(index)
    }
    
    func masterPageViewController(masterPageViewController: MasterPageViewController, didUpdatePageCount count: Int){
        print(count)
    }
}
