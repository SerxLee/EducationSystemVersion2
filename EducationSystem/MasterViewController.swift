//
//  MasterViewController.swift
//  EducationSystem
//
//  Created by Serx on 16/5/25.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit
import Observable

public var height: Observable<CGFloat> = Observable(0)
public var currentHeight: CGFloat = 0.0
public var limHeight: CGFloat = 0.0

class MasterViewController: UIViewController {
    
    var personalView: PersonSideBar!


    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var firstViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var passingButton: UIButton!
    @IBOutlet weak var semesterButton: UIButton!
    @IBOutlet weak var failButton: UIButton!
    
    var type: String!
    var userName: String!
    var passWord: String!
    var rawHeight: CGFloat!
    var minHeight: CGFloat!
    
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
        initView()
    }
    
    func initView() {
        self.classViewModel = self.logicManager.classViewModel
        self.type = "passing"
        self.classViewModel.userName = self.userName
        self.classViewModel.passWord = self.passWord
        
        self.personalView = PersonSideBar.init(frame: self.view.frame)
        self.personalView.alpha = 0
        UIApplication.sharedApplication().keyWindow?.addSubview(self.personalView)
        
        let color: UIColor = UIColor(red: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)
        self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
        
        self.rawHeight = (MasterViewController.getUIScreenSize(false) / 3.0)
        self.minHeight = MasterViewController.getUIScreenSize(false) / 5.0
        self.firstViewHeight.constant = rawHeight
        currentHeight = rawHeight
        height.afterChange += {old, new in
            self.testLengh = new
            self.changHeight()
        }
        
//        let slideGestrue: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.showSideMenu))
//        slideGestrue.direction = .Right
//        self.view.addGestureRecognizer(slideGestrue)
        
        self.screenEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.showSideMenu))
        self.screenEdgeRecognizer.edges = .Left
        self.screenEdgeRecognizer.delegate = self
        self.view.addGestureRecognizer(screenEdgeRecognizer)
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
    
    func masterPageViewController(masterPageViewController: MasterPageViewController, didUpdatePageIndex index: Int) {
        self.logicManager.getDataAfterScroll(index)
    }
    
    func masterPageViewController(masterPageViewController: MasterPageViewController, didUpdatePageCount count: Int){
        print(count)
    }
}
