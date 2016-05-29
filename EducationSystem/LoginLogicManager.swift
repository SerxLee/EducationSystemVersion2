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
            let error = operation!["err"] as! Int
            if error == 0 {
//                print(operation)
                let lim_data = operation!["data"] as! NSDictionary
                self.classViewModel.courseDataArray = lim_data["info"] as? [NSDictionary]
                studentInfo = lim_data["school_roll_info"] as? NSDictionary
                
                self.getDataFormLoginView()
                
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
                self.classViewModel.LoginSuccess <- true
            }
            else {
                print(operation!["reason"])
                let message = operation!["reason"] as! String
                print(message)
            }
        }) {  (dataTask, error) -> Void in
            print(error.code)
//            var message: String?
//            let errorCode = error.code
//            if errorCode == -1009{
//                message = "无法连接网络..."
//            }
        }
    }
    
    func getHistoryData() {
        historyDataModel.dataRead()
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
        
        noSlideLengh = self.classViewModel.deviceHeight / 4
        titleSlideLenght = self.classViewModel.deviceHeight / 6
    }
    func getDataFormLoginView() {
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