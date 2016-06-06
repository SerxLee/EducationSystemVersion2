//
//  MasterLogicManager.swift
//  EducationSystem
//
//  Created by Serx on 16/5/25.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit
import Observable

public var searchResults = [Dictionary<String, String>]()
public var searchFinished: Observable<Int> = Observable(0)

class MasterLogicManager: NSObject {
    
    var allCourseData = Dictionary<String, [Dictionary<String, String>]>()
    
    var currentSearchString: String!
    
    let classViewModel: MasterViewModel
    var type: String = "passing"
    
    var isFirst: Bool = true
    override init() {
        self.classViewModel = MasterViewModel()
        super.init()
        self.fillCourseDataFromCache(type, isFirst: true)
    }
    
    
    func getDataViaType(getType: String) {
        loginSession.willChangeValueForKey("timeoutInterval")
        loginSession.requestSerializer.timeoutInterval = 10.0
        loginSession.didChangeValueForKey("timeoutInterval")
        let URL = "https://usth.eycia.me/Score?username=\(self.classViewModel.userName)&password=\(self.classViewModel.passWord)&type=\(getType)"
        loginSession.POST(URL, parameters: nil, success: { (dataTask, response)
            in
            let err = response!["err"] as! Int
//            print(response)
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
//                    self.fillCourseData(currentSemesterCourse)
                    currentTypeAllCourse.addEntriesFromDictionary([currentSemesterTitle : currentSemesterCourse])
                }
                cacheSemester.addEntriesFromDictionary([getType : currentTypeSemesters])
                cacheSemesterNum.addEntriesFromDictionary([getType : currentTypeSemesterCount!])
                cacheCourseData.addEntriesFromDictionary([getType : currentTypeAllCourse])
                self.fillCourseDataFromCache(getType, isFirst: self.isFirst)
                if  self.classViewModel.showSearch{
                    self.fillCourseDataFromCache(getType, isFirst: true)
                }
                switch getType {
                case "semester":
                    searchFinished <- 22
                    semesterOK <- true
                case "fail":
                    searchFinished <- 33
                    failOK <- true
                default:
                    searchFinished <- 11
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
                searchFinished <- 22
                semesterOK <- true
            case "fail":
                searchFinished <- 33
                failOK <- true
            default:
                searchFinished <- 11
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
//        self.fillCourseDataFromCache(self.type, isFirst: true)
    }
    
    func fillCourseDataFromCache(type: String, isFirst: Bool){
        if cacheCourseData[type] == nil || cacheSemesterNum[type] == nil || cacheSemester[type] == nil{
            self.isFirst = false
            self.getDataViaType(type)
        }
        else {
            var limArray = [Dictionary<String, String>]()
            let allSemesters = cacheSemester[type] as! [String]
            if let dataSourse = cacheCourseData[type] as? NSMutableDictionary {
                for semester in allSemesters {
                    let currentSemesterCourse = dataSourse[semester] as! [Dictionary<String, String>]
                    for dict in currentSemesterCourse {
                        limArray.append(dict)
                    }
                }
                self.allCourseData[type] = limArray
                if !isFirst {
                    self.filterContentForSearchText(self.currentSearchString, ctype: type)
                }
            }
            else {
                NSLog("while unwrap cache data sourse ,find it is nil")
            }
        }
    }
    
    func filterContentForSearchText(searchText: String, ctype: String) {
        self.currentSearchString = searchText
        if let currentTypeCourseData = self.allCourseData[ctype] {
            searchResults = currentTypeCourseData.filter({ ( course: Dictionary<String, String>) -> Bool in
                let name = course["name"]! as String
                let nameMatch = name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return nameMatch != nil
            })
            print(searchResults)
            if ctype == "passing" {
                searchFinished <- 1
            }
            else if ctype == "semester" {
                searchFinished <- 2
            }
            else if ctype == "fail"{
                searchFinished <- 3
            }
        }
        else {
            self.fillCourseDataFromCache(ctype, isFirst: false)
        }
    }
}
