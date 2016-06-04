//
//  MasterViewController.swift
//  EducationSystem
//
//  Created by Serx on 16/5/25.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit
import Observable
import Masonry

let themeColor: UIColor = UIColor(red: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)

public var height: Observable<CGFloat> = Observable(0)
public var currentHeight: CGFloat = 0.0
public var limHeight: CGFloat = 0.0
public var currentAlpha: CGFloat = 0.0

public var observeScrollView: Observable<Int> = Observable(0)

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
    
    var searchBar: UISearchBar!
    
    var type: String!
    var userName: String!
    var passWord: String!
    var rawHeight: CGFloat = (MasterViewController.getUIScreenSize(false) / 3.0)
    var minHeight: CGFloat = 90.0
    var maxCha: CGFloat!

    var currentPageIndex: Int = 0
    
    var pageControlBar: UIView!
    var currentTitleIndex: Int = 0
    var nextPageDone: Bool = false
    var lastPageDone: Bool = false
    
    var controlBarLenght: CGFloat = MasterViewController.getUIScreenSize(true) / 3.0
    var pageIndex: Int = 0
    
    var screenEdgeRecognizer: UIScreenEdgePanGestureRecognizer!
    var currentRadius:CGFloat = 0.0
    
    var masterPageViewController: MasterPageViewController? {
        didSet {
            masterPageViewController?.masterDelegate = self
        }
    }
    
    var searchBarShow: Bool = false
    
    var classViewModel: MasterViewModel!
    var logicManager: MasterLogicManager = { return MasterLogicManager() }()
    
    var testLengh: CGFloat = 0.0

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.searchBarShow {
            self.navigationController?.navigationBar.lt_setBackgroundColor(themeColor.colorWithAlphaComponent(1))
        }
        else {
            self.navigationController?.navigationBar.lt_setBackgroundColor(themeColor.colorWithAlphaComponent(currentAlpha))

        }
    }
    
    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        self.firstView.frame = CGRectMake(0, 0, MasterViewController.getUIScreenSize(true), rawHeight)
//        self.containerView.frame = CGRectMake(0, rawHeight, MasterViewController.getUIScreenSize(true), MasterViewController.getUIScreenSize(false) - rawHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initObservable()
        self.initSearchBar()
    }
    
    func initView() {

        //set the page bar
        let reck = CGRectMake((self.controlBarLenght - 64.0) / 2.0 , -7, 64, 6)
        self.pageControlBar = UIView(frame: reck)
        self.pageControlBar.backgroundColor = themeColor.colorWithAlphaComponent(0.7)
        self.pageControlBar.layer.cornerRadius = 3.0
        self.containerView.addSubview(self.pageControlBar)
        
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
        
        self.navigationController?.navigationBar.lt_setBackgroundColor(themeColor.colorWithAlphaComponent(0))
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.hideBottomHairline()
        
        self.minHeight = 90.0
        self.firstViewHeight.constant = rawHeight
        self.maxCha = self.rawHeight - minHeight
        
        currentHeight = rawHeight
        

        
        self.screenEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.dragSideMenu(_:)))
        self.screenEdgeRecognizer.edges = .Left
        self.screenEdgeRecognizer.delegate = self
        self.view.addGestureRecognizer(screenEdgeRecognizer)
        
        self.passingButtonToLeftBargin.constant = (self.controlBarLenght - 64.0) / 2.0
        self.failButtonToRightBargin.constant = (self.controlBarLenght - 46) / 2.0
    }
    
    //MARK: init all observable properties

    func initObservable() {
        
        height.afterChange += {old, new in
            self.testLengh = new
            self.changHeight()
        }
        
        /**
         via the observeScrollView to controller the control bar slide before the page animation finish
         
         there three state:
         
         1: dicatied to slide to the next title
         
         2: if the bar not slide before the gestrure finish before, it will not fire (slideControlBar) method
         if the bar slide before, change the current title index as older value, and fire  (slideControlBar) method
         
         3: dicatied to slide to the last title
         */
        observeScrollView.afterChange += { old, new
            in
            if new == 1 {
                if !self.nextPageDone {
                    self.currentTitleIndex += 1
                    self.slideControlBar()
                    self.nextPageDone = true
                }
            }
            else if new == -1{
                if !self.lastPageDone {
                    self.currentTitleIndex -= 1
                    self.slideControlBar()
                    self.lastPageDone = true
                }
            }
            else if new == 2{
                if self.currentTitleIndex != self.currentPageIndex {
                    self.currentTitleIndex = self.currentPageIndex
                    self.slideControlBar()
                    self.nextPageDone = false
                    self.lastPageDone = false
                }
            }
            //            print(self.currentTitleIndex)
        }
        
    }
    
    //
    func initSearchBar() {
        let rect = CGRectMake(0, 20.0, MasterViewController.getUIScreenSize(false), 44.0)
        self.searchBar = UISearchBar(frame: rect)
        self.searchBar.backgroundColor = themeColor
        self.searchBar.placeholder = "输入课程关键字"
        self.searchBar.alpha = 0
        
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.barTintColor = themeColor
        
        self.searchBar.delegate = self
        
        if let searchField = self.searchBar.valueForKey("searchField") {
            searchField.layer.cornerRadius = 14.0
            searchField.layer.borderWidth = 0
            searchField.layer.masksToBounds = true
        }
        self.firstView.addSubview(self.searchBar)
    }
    
    func slideControlBar() {
        var reck = CGRectMake((self.controlBarLenght - 64.0) / 2.0 , -7, 64, 6)
        if self.currentTitleIndex == 0 {
            reck = CGRectMake((self.controlBarLenght - 64.0) / 2.0 , -7, 64, 6)
        }
        else if self.currentTitleIndex == 1 {
            reck = CGRectMake((self.controlBarLenght - 46) / 2.0 + self.controlBarLenght, -7, 46, 6)
        }
        else if self.currentTitleIndex == 2 {
            reck = CGRectMake((self.controlBarLenght - 46) / 2.0 + 2 * self.controlBarLenght, -7, 46, 6)
        }
        UIView.animateWithDuration(0.4, animations: {
            self.pageControlBar.frame = reck
        })
        //
        observeScrollView <- 0
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.lt_reset()
    }
    
    func changHeight() {
//        let limlenght = rawHeight - self.testLengh
//        let width = MasterViewController.getUIScreenSize(true)
//        let height = MasterViewController.getUIScreenSize(false)
        self.testLengh = height.value
        if self.rawHeight - self.testLengh <= minHeight {
            currentAlpha = 1.0
            return
        }
        self.firstViewHeight.constant = rawHeight - self.testLengh
        currentHeight = self.firstViewHeight.constant
        
        ///change the navigationbar alpha
        if self.testLengh > NAVBAR_CHANGE_POINT {
            let alpha: CGFloat = 1.0 - ((maxCha - self.testLengh) / maxCha)
            currentAlpha = alpha
            self.navigationController?.navigationBar.lt_setBackgroundColor(themeColor.colorWithAlphaComponent(alpha))
        }
        else {
            self.navigationController?.navigationBar.lt_setBackgroundColor(themeColor.colorWithAlphaComponent(0))
        }
    }
    @IBAction func showSideBar(sender: AnyObject) {
        showSideMenu()
    }
    
    @IBAction func rightBarItem(sender: AnyObject) {

        self.searchBarShow = !self.searchBarShow
        if searchBarShow {
            self.firstViewHeight.constant = 94
            UIView.animateWithDuration(0.2, animations: {
                self.navigationController?.navigationBar.lt_setBackgroundColor(themeColor)
                self.view.layoutIfNeeded()
            }) { (complete) in
                self.searchBar.alpha = 1.0
                self.firstViewHeight.constant = 130
                UIView.animateWithDuration(0.1, animations: {
                    self.searchBar.frame = CGRectMake(0, 56, MasterViewController.getUIScreenSize(true), 44)
                    self.view.layoutIfNeeded()
                })
            }
            height.unshare(removeSubscriptions: true)
        }
        else if !self.searchBarShow {
            self.firstViewHeight.constant = 94
            self.recoverTableViewData()
            
            UIView.animateWithDuration(0.1, animations: { 
                self.searchBar.frame = CGRectMake(0, 20, MasterViewController.getUIScreenSize(true), 44)
                self.view.layoutIfNeeded()
                }, completion: { (complete) in
                    self.searchBar.alpha = 0
                    self.searchBar.text = ""
                    self.changHeight()
                    UIView.animateWithDuration(0.2, animations: { 
                        self.navigationController?.navigationBar.lt_setBackgroundColor(themeColor.colorWithAlphaComponent(currentAlpha))
                        self.view.layoutIfNeeded()
                        }, completion: { (complete) in
                            height.afterChange += {old, new in
                                self.testLengh = new
                                self.changHeight()
                            }
                    })
            })
        }
    }
    func recoverTableViewData() {
        switch self.type {
        case "passing":
            searchFinished <- 11
            case "semester":
            searchFinished <- 22
            case "fail":
            searchFinished <- 33
        default:
            NSLog("error current type:\(type)")
        }
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
    
    var button: UIBarButtonItem!
    @IBAction func segmentAction(sender: UISegmentedControl) {
        let title = self.titleBarSegment.titleForSegmentAtIndex(self.titleBarSegment.selectedSegmentIndex)!
        if title == "学习情况" {
            self.button = self.navigationItem.rightBarButtonItem
            UIView.animateWithDuration(0.2, animations: {
                self.situationContainer.alpha = 1.0
                self.navigationController?.navigationBar.lt_setBackgroundColor(themeColor.colorWithAlphaComponent(1.0))
                self.navigationItem.rightBarButtonItem = nil
            })
            startLoadChart <- 1
//            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SituationView")
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if title == "成绩总览" {
            UIView.animateWithDuration(0.2, animations: {
                self.situationContainer.alpha = 0
                self.navigationItem.rightBarButtonItem = self.button
                if self.searchBarShow {
                    self.navigationController?.navigationBar.lt_setBackgroundColor(themeColor.colorWithAlphaComponent(1))
                }
                else {
                    self.navigationController?.navigationBar.lt_setBackgroundColor(themeColor.colorWithAlphaComponent(currentAlpha))
                }
            })
            startLoadChart <- 0
        }
    }

    @IBAction func clickSemesterButton(sender: UIButton) {
        self.searchBar.text = ""
        self.type = "semester"
        self.logicManager.checkCurrentTypeCourseIsExist(self.type)
        self.masterPageViewController?.scrollToViewController(index: 1)
    }
    @IBAction func clickPassingButton(sender: UIButton) {
        self.searchBar.text = ""
        self.type = "passing"
        self.logicManager.checkCurrentTypeCourseIsExist(self.type)
        self.masterPageViewController?.scrollToViewController(index: 0)
    }
    @IBAction func clickFailButton(sender: UIButton) {
        self.searchBar.text = ""
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

//extension MasterViewController: UISearchResultsUpdating {
//    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        let searchText = self.searchBar.text
//        self.logicManager.filterContentForSearchText(searchText!, type: self.type)
//    }
//}

extension MasterViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchBar.text!
        
        self.logicManager.filterContentForSearchText(searchText, ctype:self.type)
    }
}

extension MasterViewController: MasterPageViewControllerDelegate {
    
    //page View ture to page and reload the table view
    func masterPageViewController(masterPageViewController: MasterPageViewController, didUpdatePageIndex index: Int) {
        self.logicManager.getDataAfterScroll(index)
        self.currentPageIndex = index
    }
    
    func masterPageViewController(masterPageViewController: MasterPageViewController, didUpdatePageCount count: Int){
        print(count)
    }
}