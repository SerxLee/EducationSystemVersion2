//
//  LoginViewController2.swift
//  EducationSystem
//
//  Created by Serx on 16/6/5.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Observable
import AFNetworking
import SVProgressHUD

public let loginSession2 = AFHTTPSessionManager()

class NewLoginViewController: UIViewController {
    
    var userName: UITextField!
    var passWord: UITextField!
    var formView: UIView!
    var horizontalLine: UIView!
    var confirmButton:UIButton!
    var titleLabel: UILabel!
    var historyTableView: UITableView!
    
    var topConstraint: Constraint?
    var historyHeight: Constraint?
    var loginConstraint: Constraint?
    var loginConstraintValue: CGFloat = 20.0
    
    var classViewModel: LoginViewModel!
    lazy var logicManager : LoginLogicManager = {
        return LoginLogicManager()
    }()
    
    override func viewDidLoad() {
        self.initProperties()
        super.viewDidLoad()
        self.initView()
    }
    
    func initView() {
        
        self.view.backgroundColor = themeColor
        
        let formViewHeight = 90
        
//        let tapView = UITapGestureRecognizer(target: self, action: #selector(self.hideKyeBoard))
//        self.view.userInteractionEnabled = true
//        self.view.addGestureRecognizer(tapView)
        
        self.formView = UIView()
        self.formView.layer.borderWidth = 0.5
        self.formView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.formView.backgroundColor = UIColor.whiteColor()
        self.formView.layer.cornerRadius = 5
        self.view.addSubview(self.formView)
        
        self.formView.snp_makeConstraints { (make) -> Void in
//            make.left.equalTo(15)
//            make.right.equalTo(-15)
            make.centerX.equalTo(self.view)
            make.width.equalTo(224)
            //存储top属性
            self.topConstraint = make.centerY.equalTo(self.view).constraint
            make.height.equalTo(formViewHeight)
        }
        
        self.horizontalLine =  UIView()
        self.horizontalLine.backgroundColor = UIColor.lightGrayColor()
        self.formView.addSubview(self.horizontalLine)
        self.horizontalLine.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(0.5)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.centerY.equalTo(self.formView)
        }
        
        let imgLock1 =  UIImageView(frame:CGRectMake(11, 11, 22, 22))
        imgLock1.image = UIImage(named:"userImage")
        let userTap = UIGestureRecognizer(target: self, action: #selector(self.userImageTapAction(_:)))
        imgLock1.userInteractionEnabled = true
        imgLock1.addGestureRecognizer(userTap)
        
        let imgLock2 =  UIImageView(frame:CGRectMake(11, 11, 22, 22))
        imgLock2.image = UIImage(named:"psdImage")
        imgLock2.userInteractionEnabled = true
        //TODO: add gestrue
        let tap = UITapGestureRecognizer(target: self, action: #selector((self.pasImageTapAction(_:))))
        imgLock2.addGestureRecognizer(tap)
        
        self.userName = UITextField()
        self.userName.delegate = self
        self.userName.placeholder = "学号"
        self.userName.tag = 100
        self.userName.leftView = UIView(frame:CGRectMake(0, 0, 44, 44))
        self.userName.leftViewMode = UITextFieldViewMode.Always
        self.userName.returnKeyType = UIReturnKeyType.Next
        self.userName.addTarget(self, action: #selector(self.userNameEidtingChanged(_:)), forControlEvents: .EditingChanged)
        
        self.userName.leftView!.addSubview(imgLock1)
        self.formView.addSubview(self.userName)
        
        self.userName.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
            make.centerY.equalTo(0).offset(-formViewHeight/4)
        }
        
        self.passWord = UITextField()
        self.passWord.delegate = self
        self.passWord.placeholder = "密码"
        self.passWord.tag = 101
        self.passWord.leftView = UIView(frame:CGRectMake(0, 0, 44, 44))
        self.passWord.leftViewMode = UITextFieldViewMode.Always
        self.passWord.returnKeyType = UIReturnKeyType.Go
        self.passWord.secureTextEntry = true
        
        self.passWord.leftView!.addSubview(imgLock2)
        self.formView.addSubview(self.passWord)
        
        self.passWord.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
            make.centerY.equalTo(0).offset(formViewHeight/4)
        }
        
        self.confirmButton = UIButton()
        self.confirmButton.setTitle("登录", forState: UIControlState.Normal)
        self.confirmButton.setTitleColor(UIColor.blackColor(),
                                         forState: UIControlState.Normal)
        self.confirmButton.layer.cornerRadius = 5
        self.confirmButton.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.5)
        self.confirmButton.addTarget(self, action: #selector(loginConfrim),
                                     forControlEvents: .TouchUpInside)
        self.view.addSubview(self.confirmButton)
        self.confirmButton.snp_makeConstraints { (make) -> Void in
//            make.left.equalTo(15)
            self.loginConstraint = make.top.equalTo(self.formView.snp_bottom).offset(20).constraint
//            make.right.equalTo(-15)
            make.height.equalTo(44)
            make.centerX.equalTo(self.view)
            make.width.equalTo(224)
        }
        
        self.titleLabel = UILabel()
        self.titleLabel.text = "URP综合教务系统"
        self.titleLabel.textColor = UIColor.whiteColor()
        self.titleLabel.font = UIFont.systemFontOfSize(28)
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.formView.snp_top).offset(-20)
            make.centerX.equalTo(0)
            make.height.equalTo(44)
        }
        
        let historyTableViewHeight: CGFloat = 0
        
        self.historyTableView = UITableView()
        self.historyTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        self.historyTableView.delegate = self
        self.historyTableView.dataSource = self
        self.historyTableView.tableFooterView = UIView()
        self.historyTableView.layer.cornerRadius = 5.0
        self.historyTableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.historyTableView)
        self.historyTableView.snp_makeConstraints { (make) in
            make.left.equalTo(self.formView.snp_left).offset(80)
            make.right.equalTo(self.formView.snp_right).offset(-0.5)
            self.historyHeight = make.height.equalTo(historyTableViewHeight).constraint
            make.top.equalTo(self.formView.snp_bottom).offset(-44)
        }
    }
    
    func initProperties() {
        self.classViewModel = self.logicManager.classViewModel  //set the login view model local

        self.classViewModel.LoginSuccess.afterChange += {old, new in
            if new == 1 {
                SVProgressHUD.showSuccessWithStatus("登录成功")
                self.classViewModel.LoginSuccess <- 0
                let nextController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MasterNavigation") as! UINavigationController
                let master = nextController.topViewController as! MasterViewController
                master.userName = self.userName.text!
                master.passWord = self.passWord.text!
                self.presentViewController(nextController, animated: true, completion: nil)
                
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
        
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Light)
        SVProgressHUD.setBackgroundLayerColor(themeColor)
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
    }
    
    func hideKyeBoard() {
        self.view.endEditing(true)
        self.hideHistoryTable()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.topConstraint?.updateOffset(0)
            self.view.layoutIfNeeded()
        })

    }
    
    func userImageTapAction(tapGestrue: UITapGestureRecognizer) {
        self.userName.becomeFirstResponder()
    }
    
    func pasImageTapAction(tapGestrue: UITapGestureRecognizer) {
        self.hideHistoryTable()
        self.passWord.becomeFirstResponder()
    }
    
    func hideHistoryTable() {
        if self.loginConstraintValue > 20 {
            UIView.animateWithDuration(0.1, animations: { 
                self.loginConstraint?.updateOffset(20)
                self.view.layoutIfNeeded()
            })
        }
        UIView.animateWithDuration(0.3, animations: {
            self.historyHeight?.updateOffset(0)
            self.view.layoutIfNeeded()
        })
    }
    
    func userNameEidtingChanged(textFiled: UITextField) {
        if let statueCode = logicManager.didChange(textFiled) {
            if statueCode == 0 {
                self.hideHistoryTable()
            }
            else {
                let height = CGFloat(statueCode) - 1
                
//                UIView.animateWithDuration(0.3, animations: { 
//                    self.historyHeight?.updateOffset(height)
//                    self.view.layoutIfNeeded()
//                })
                self.showHistoryWithHeight(height)
                self.historyTableView.reloadData()
            }
        }
    }
    
    var currentlogin: CGFloat! = 20
    var oldTableViewHeight: CGFloat = 0
    
    func showHistoryWithHeight(height: CGFloat) {
        let MAX_FIRST_TABLE: CGFloat = 64
        if height <= MAX_FIRST_TABLE {
            self.loginConstraintValue = 20.0
            if self.oldTableViewHeight >= 64 {
//                let CHA: CGFloat = oldTableViewHeight - 64
                
                UIView.animateWithDuration(0.1, animations: {
                    self.historyHeight?.updateOffset(MAX_FIRST_TABLE)
                    self.loginConstraint?.updateOffset(20)
                    self.view.layoutIfNeeded()
                    
                    }, completion: { (complete) in
                        UIView.animateWithDuration(0.2, animations: { 
                            self.historyHeight?.updateOffset(height)
                            self.view.layoutIfNeeded()
                        })
                })
            }
            else {
                UIView.animateWithDuration(0.2, animations: {
                    self.historyHeight?.updateOffset(height)
                    self.view.layoutIfNeeded()
                })
            }
        }
        else {
            let CHA = height - MAX_FIRST_TABLE
//            if oldTableViewHeight != 0 {
//                CHA = height - self.oldTableViewHeight
//            }
            self.loginConstraintValue = 20 + CHA
            if oldTableViewHeight < 64{
                UIView.animateWithDuration(0.2, animations: {
                    self.historyHeight?.updateOffset(MAX_FIRST_TABLE)
                    self.view.layoutIfNeeded()
                    
                    }, completion: { (complete) in
                        UIView.animateWithDuration(0.2, animations: {
                            self.loginConstraint?.updateOffset(20 + CHA)
                            self.historyHeight?.updateOffset(height)
                            self.view.layoutIfNeeded()
                        })
                })
            }else if oldTableViewHeight >= 64 {
                UIView.animateWithDuration(0.2, animations: { 
                    UIView.animateWithDuration(0.2, animations: {
                        self.loginConstraint?.updateOffset(20 + CHA)
                        self.historyHeight?.updateOffset(height)
                        self.view.layoutIfNeeded()
                    })
                })
            }

        }
        self.oldTableViewHeight = height

    }
    
    
    func loginConfrim(){
        //get up the key board
        self.view.endEditing(true)
        self.hideHistoryTable()
        //recover all as the first position
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.topConstraint?.updateOffset(0)
            self.view.layoutIfNeeded()
        })
        self.logicManager.checkLoginInformation(userName.text!, password: passWord.text!)
        SVProgressHUD.show()
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
}

extension NewLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        let tag = textField.tag
        switch tag {
        case 100:
            self.hideHistoryTable()
            self.passWord.becomeFirstResponder()
        case 101:
            loginConfrim()
        default:
            print(textField.text)
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField:UITextField) {
        
        if textField.tag == 101 {
            self.hideHistoryTable()
        }
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.topConstraint?.updateOffset(-125)
            self.view.layoutIfNeeded()
        })
    }
}

extension NewLoginViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        self.userName.text = self.classViewModel.matchResultArray[row]
        
        self.hideHistoryTable()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension NewLoginViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classViewModel.matchResultArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 25
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier: String = "myCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        let row = indexPath.row
        cell.textLabel?.text = self.classViewModel.matchResultArray[row]
        cell.textLabel?.textAlignment = .Center
        cell.textLabel?.font = UIFont.boldSystemFontOfSize(15)
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)
        return cell
    }
}