//
//  LoginLogicManager.swift
//  EducationSystem
//
//  Created by Serx on 16/5/23.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import Foundation
import UIKit
import Observable

class LoginLogicManager: NSObject{
    
    let type: String = "passing"
    
    ///create the notification's keyPath
    static let FLICKR_DATA_COMPLETE:String = "flickrDataComplete"
    let classViewModel: LoginViewModel
    
    lazy var historyDataModel : HistoryDataModel = {
        return HistoryDataModel()
    }()
    
    /**
        set some Observable propertise
    */
    var courseChange: Observable<Int> = Observable(1)
    var matchArrayChange: Observable<Int> = Observable(1)

    
    override init() {
        self.classViewModel = LoginViewModel()
        super.init()
        self.getHistoryData()
        self.getDeviceSize()
    }
    
    func checkLoginInformation(username: String, password: String) {
        let myParameters: Dictionary = ["username":username, "password": password, "type": "passing"]
        loginSession.POST(classViewModel.checkURL, parameters: myParameters, success: {  (dataTask, operation) -> Void in
            
            let err = operation!["err"] as! Int
            if err == 0 {
                NSLog("login success")
//                print(operation)
                let lim_data = operation!["data"] as! NSDictionary
                self.classViewModel.courseDataArray = lim_data["info"] as? [NSDictionary]
                studentInfo = lim_data["school_roll_info"] as? NSDictionary
//                print(studentInfo)
                
                self.putDataToCache()
                
                self.courseChange <- (0 - self.courseChange.value) ///change the Observable propertise and notifica the login view to update
                /**
                    if the username is not exist
                    add it into view model's historyArray and write the array into .plist file
                */
                if self.classViewModel.historyArray.count == 0 {
                    self.classViewModel.historyArray.append(username)
                    let limMutableArray = NSMutableArray(array: self.classViewModel.historyArray)
                    self.historyDataModel.toWriteArray = limMutableArray
                    self.historyDataModel.dataWrite()
                }
                else {
                    var hasSaved = false
                    for str in self.classViewModel.historyArray {
                        if username == str {
                            hasSaved = true
                        }
                    }
                    if !hasSaved {
                        self.classViewModel.historyArray.append(username)
                        let limMutableArray = NSMutableArray(array: self.classViewModel.historyArray)
                        self.historyDataModel.toWriteArray = limMutableArray
                        self.historyDataModel.dataWrite()
                    }
                }
                self.classViewModel.LoginSuccess <- 1
            }
            else if err == 1{
                NSLog("fine error while login")
//                print(operation)
                let reason = operation["reason"] as! String
                self.classViewModel.LoginSuccess <- 2
                self.classViewModel.errorMessege1 = reason
                NSLog(reason)
            }
            else {
                NSLog("unknow error while login")
                let reason = operation["reason"] as! String
                self.classViewModel.LoginSuccess <- 2
                self.classViewModel.errorMessege1 = reason
                NSLog(reason)
            }
        }) {  (dataTask, error) -> Void in
            self.classViewModel.LoginSuccess <- 3
            self.classViewModel.errorMessege2 = String(error.code)
            NSLog("network error while login")
            print(error)
        }
    }
    
    func getHistoryData() {
        historyDataModel.dataRead(false)
        classViewModel.historyArray = historyDataModel.toReadArray
    }
    
    /*
     oberver the userName TextField, if the text change ,
     the target will tigger the 'didChange' method
     */
    func didChange(textField: UITextField) -> Int? {
        //TODO
        let statueCode: Int?
        let currentStr = textField.text!
        if currentStr.isEmpty {
            statueCode = 0
        }
        else {
            /*
             match the storage userName data,
             resultData is the matched data
             */
            self.classViewModel.matchResultArray = historyDataModel.sl_matchlist(classViewModel.historyArray, strCmp: currentStr)
            print(self.classViewModel.matchResultArray)
            let matchResultCount = self.classViewModel.matchResultArray.count
            if matchResultCount > 0 {
                //auto fix
                if matchResultCount <= 5 { statueCode = matchResultCount * 25 }
                else { statueCode = 125 }
            }
            else { statueCode = 0 }
        }
        return statueCode
    }
    
    func getDeviceSize(){
        let panDevice = currentDevice()
        let type = panDevice.getInfo()
        var height: CGFloat = 0.0
        var width: CGFloat = 0.0
        switch type {
        case .iphone6plus:
            height = 736
            width = 414
        case .iphone6:
            height = 667
            width = 375
        case .iphone5:
            height = 568
            width = 320
        case .iphone4:
            height = 480
            width = 320
        default:
            height = 1024
            width = 768
        }
        self.classViewModel.deviceHeight = height
        self.classViewModel.deviceWidth = width
        
        //MARK: change here
//        noSlideLengh = self.classViewModel.deviceHeight / 4
//        titleSlideLenght = self.classViewModel.deviceHeight / 6
    }
    func putDataToCache() {
        var currentTypeSemesters = [String]()
        let currentTypeSemesterCount = self.classViewModel.courseDataArray!.count
        let currentTypeAllCourse = NSMutableDictionary()
        for dic in self.classViewModel.courseDataArray! {
            let currentSemesterTitle = dic["block_name"] as! String
            currentTypeSemesters.append(currentSemesterTitle)
            let currentSemesterCourse = dic["courses"] as! [NSDictionary]
            currentTypeAllCourse.addEntriesFromDictionary([currentSemesterTitle : currentSemesterCourse])
        }
        cacheSemester.addEntriesFromDictionary([self.type : currentTypeSemesters])
        cacheSemesterNum.addEntriesFromDictionary([self.type : currentTypeSemesterCount])
        cacheCourseData.addEntriesFromDictionary([self.type : currentTypeAllCourse])
    }
}