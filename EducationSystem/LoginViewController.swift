//
//  LoginViewController.swift
//  EducationSystem
//
//  Created by Serx on 16/5/23.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit
import Foundation
import AFNetworking
import Observable
import SVProgressHUD

public let loginSession = AFHTTPSessionManager()

class LoginViewController: UIViewController {
    
    @IBOutlet weak var titleToTopBoundContraint: NSLayoutConstraint!
    @IBOutlet weak var pasTitleToUsernameContraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHight: NSLayoutConstraint!
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var LoginBotton: UIButton!
    
    var classViewModel: LoginViewModel!
    lazy var logicManager : LoginLogicManager = {
        return LoginLogicManager()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    
    
    func initView() {
        self.classViewModel = self.logicManager.classViewModel  //set the login view model local
        self.userName.delegate = self
        self.userName.returnKeyType = .Next
        self.passWord.delegate = self
        self.passWord.returnKeyType = .Go
        self.LoginBotton.layer.cornerRadius = 5.0
        self.historyTableView.delegate = self
        self.historyTableView.dataSource = self
        self.titleToTopBoundContraint.constant = noSlideLengh
        
        self.hideHistoryTableView(true)
        //add the action to userName,
        self.userName.addTarget(self, action: #selector(self.userNameChange(_:)),forControlEvents: .EditingChanged)
        self.userName.addTarget(self, action: #selector(self.didEndEditing(_:)), forControlEvents: .EditingDidEnd)
        self.passWord.addTarget(self, action: #selector(self.pawBeginEdit), forControlEvents: UIControlEvents.EditingDidBegin)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.TestNotificationCenter(_:)), name: LoginLogicManager.FLICKR_DATA_COMPLETE, object: nil)
        self.logicManager.courseChange.afterChange += { old, new in
//            print("\(old) change to \(new)")
        }
        self.classViewModel.LoginSuccess.afterChange += {old, new in
            self.shouldPerformSegueWithIdentifier("LoginToMater", sender: nil)
            if new == 1 {
                SVProgressHUD.showSuccessWithStatus("登录成功")
                self.classViewModel.LoginSuccess <- 0
                self.performSegueWithIdentifier("LoginToMater", sender: nil)
            }
            else if new == 2 {
                SVProgressHUD.showErrorWithStatus(self.classViewModel.errorMessege1)
                self.classViewModel.LoginSuccess <- 0
            }
            else if new == 3 {
                SVProgressHUD.showErrorWithStatus("错误代码：\(self.classViewModel.errorMessege2)")
                self.classViewModel.LoginSuccess <- 0
            }
        }
        
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Dark)
        SVProgressHUD.setForegroundColor(themeColor)
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)

    }

    func pawBeginEdit(){
        self.hideHistoryTableView(true)
    }
    
    func didEndEditing(textFile: UITextField) {
        self.hideHistoryTableView(false)
    }
    
    func userNameChange(textFiled: UITextField) {
        if let statueCode = logicManager.didChange(textFiled) {
            if statueCode == 0 {
                self.hideHistoryTableView(true)
            }
            else {
                let height = CGFloat(statueCode)
                self.hideHistoryTableView(false, tableViewHeight: height)
                
            }
        }
    }
    
    /**
        hide the hitory table view:
            just set the .hiden to true
    */
    private func hideHistoryTableView(hiden: Bool, tableViewHeight: CGFloat = 0.0) {
        self.historyTableView.hidden = hiden
        if hiden {
            self.pasTitleToUsernameContraint.constant = 8.0
        }else {
            self.pasTitleToUsernameContraint.constant = tableViewHeight
            self.historyTableView.reloadData()
            self.tableViewHight.constant = tableViewHeight
        }
        UIView.animateWithDuration(0.2) { 
            self.view.layoutIfNeeded()
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "LoginToMater" {
            let account = userName.text
            let password = passWord.text
            let limValue = self.classViewModel.LoginSuccess.value
            if account == "" || password == "" || limValue == 2 || limValue == 3 || limValue == 0{
                return false
            }
        }
        //MARK: dddd
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LoginToMater" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let nextViewController = navigationController.topViewController as! MasterViewController
            nextViewController.userName = self.userName.text!
            nextViewController.passWord = self.passWord.text!
        }
    }
    
    @IBAction func LoginBottonClick(sender: AnyObject) {
        self.textFieldShouldReturn(userName)
        self.textFieldShouldReturn(passWord)
    }
}

    /**
        while enter the textField editing,
        you move all UI implement up Slidlenght
    */
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
            self.titleToTopBoundContraint.constant = titleSlideLenght
            UIView.animateWithDuration(0.2) {
                self.view.layoutIfNeeded()
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == userName {
            self.userName.resignFirstResponder()
            self.passWord.becomeFirstResponder()
            self.hideHistoryTableView(true)
        }
        else if textField ==  passWord {
            self.logicManager.checkLoginInformation(userName.text!, password: passWord.text!)
            self.passWord.resignFirstResponder()
            self.titleToTopBoundContraint.constant = noSlideLengh
            UIView.animateWithDuration(0.2, animations: { 
                self.view.layoutIfNeeded()
            })
            SVProgressHUD.show()
        }
        return true
    }
}

extension LoginViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! HistoryTableViewCell
        self.userName.text = cell.userName.text!
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        hideHistoryTableView(true)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableViewCellHeight
    }
}

extension LoginViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classViewModel.matchResultArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "myCell"
        let row = indexPath.row
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! HistoryTableViewCell
        
        cell.userName.text = self.classViewModel.matchResultArray[row]
        return cell
    }
}


var titleSlideLenght: CGFloat = 50.0
var noSlideLengh: CGFloat = 110.0
let tableViewCellHeight: CGFloat = 25.0
