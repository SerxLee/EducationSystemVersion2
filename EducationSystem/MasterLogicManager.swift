//
//  MasterLogicManager.swift
//  EducationSystem
//
//  Created by Serx on 16/5/25.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit
import Observable

class MasterLogicManager: NSObject {
    
    let classViewModel: MasterViewModel
    var type: String = "passing"
    override init() {
        self.classViewModel = MasterViewModel()
        super.init()
    }
    
    func getDataViaType(getType: String) {
        let URL = "https://usth.eycia.me/Score?username=\(self.classViewModel.userName)&password=\(self.classViewModel.passWord)&type=\(getType)"
        loginSession.POST(URL, parameters: nil, success: { (dataTask, response)
            in
            let err = response!["err"] as! Int
            //the data back is not error
            if err == 0 {
                NSLog("get more data success")
                let currentTypeData = response!["data"] as! NSDictionary
                var currentTypeSemesters = [String]()
                self.classViewModel.courseDataArray = currentTypeData["info"] as? [NSDictionary]
                let currentTypeSemesterCount = self.classViewModel.courseDataArray?.count
                let currentTypeAllCourse = NSMutableDictionary()
                for dic in self.classViewModel.courseDataArray! {
                    let currentSemesterTitle = dic["block_name"] as! String
                    //put all semester's title in 'allSemesters' array
                    currentTypeSemesters.append(currentSemesterTitle)
                    let currentSemesterCourse = dic["courses"] as! [NSDictionary]
                    currentTypeAllCourse.addEntriesFromDictionary([currentSemesterTitle : currentSemesterCourse])
                }
                cacheSemester.addEntriesFromDictionary([getType : currentTypeSemesters])
                cacheSemesterNum.addEntriesFromDictionary([getType : currentTypeSemesterCount!])
                cacheCourseData.addEntriesFromDictionary([getType : currentTypeAllCourse])
                switch getType {
                case "semester":
                    semesterOK <- true
                case "fail":
                    failOK <- true
                default:
                    break
                }
            }
            else if err == 1{
                NSLog("fine error while get more data")
                let reason = response["reason"] as! String
                NSLog(reason)
            }
            else {
                NSLog("unknow error while get more data")
                let reason = response["reason"] as! String
                NSLog(reason)
            }
            })
        {  (dataTask, error) -> Void in
            NSLog(error.localizedDescription)
        }
    }
    
    func checkCurrentTypeCourseIsExist(typeGet: String) {
        /*
         1. inspect 'cacheCourseData', 'cacheSemesterNum', 'cacheSemester' of current's title
         
         .. 1. if values of the title did not search before, the value will be nil
         and tigger the then 'getDataViaType' method to get the data from
         
         .. 2. else the value of the title is not nil, indicate that you have search before
         and you can read the data referent current title directly.
         
         */
        if cacheCourseData[typeGet] == nil || cacheSemesterNum[typeGet] == nil || cacheSemester[typeGet] == nil{
            self.getDataViaType(typeGet)
        }else{
            switch typeGet {
            case "semester":
                semesterOK <- true
            case "fail":
                failOK <- true
            default:
                break
            }
        }
    }
    
    
    func getDataAfterScroll(index: Int) {
        if index == 0 {
            self.type = "passing"
        }
        else if index == 1 {
            self.type = "semester"
        }
        else {
            self.type = "fail"
        }
        self.checkCurrentTypeCourseIsExist(self.type)
    }
    /*
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
        NSLog("first")
        cacheSemester.addEntriesFromDictionary([self.type : currentTypeSemesters])
        cacheSemesterNum.addEntriesFromDictionary([self.type : currentTypeSemesterCount])
        cacheCourseData.addEntriesFromDictionary([self.type : currentTypeAllCourse])
        passingGetDataOK <- true
    }
    */
}
