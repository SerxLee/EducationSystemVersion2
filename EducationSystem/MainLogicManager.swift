//
//  MainLogicManager.swift
//  EducationSystem
//
//  Created by Serx on 16/5/23.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import Foundation

class MainLogicManager: NSObject {
    
    let classViewModel: MainViewModel
    
    let type: String = "passing"
    var DataSourse : NSMutableDictionary!
    
    override init() {
        self.classViewModel = MainViewModel()
        super.init()
    }
    
    func getDataViaType(getType: String) {
        let URL = "https://usth.eycia.me/Score?username=\(self.classViewModel.userName)&password=\(self.classViewModel.passWord)&type=\(getType)"
        loginSession.POST(URL, parameters: nil, success: { (dataTask, response)
            in
            let error = response!["err"] as! Int
            if error == 0 {
                let lim_data = response!["data"] as! NSDictionary
                self.classViewModel.allCourse = lim_data["info"] as! [NSDictionary]
                self.classViewModel.semestersNum = self.classViewModel.allCourse.count
                
                let limm = NSMutableDictionary()
                for dic in self.classViewModel.allCourse{
                    
                    let dicType = dic["block_name"] as! String
                    
                    //put all semester's title in 'allSemesters' array
                    self.classViewModel.allSemesters.append(dicType)
                    let lim = dic["courses"] as! [NSDictionary]
                    
                    limm.addEntriesFromDictionary([dicType : lim])
                }
                self.DataSourse = limm
                cacheSemester.addEntriesFromDictionary([getType : self.classViewModel.allSemesters])
                cacheSemesterNum.addEntriesFromDictionary([getType : self.classViewModel.semestersNum])
                cacheCourseData.addEntriesFromDictionary([getType : limm])
            }
            else{
                //the data get back is error
                NSLog("获取数据失败")
            }
        })
        {  (dataTask, error) -> Void in
            //while errro thlie connect to serer
            NSLog(error.localizedDescription)
        }
    }
    
    func changeType(){
        
    }
    
    func getDataInAllCourse() {
        self.classViewModel.allCourse.count
        let limm = NSMutableDictionary()
        for dic in self.classViewModel.allCourse{
            let dicType = dic["block_name"] as! String
            self.classViewModel.allSemesters.append(dicType)
            let lim = dic["courses"] as! [NSDictionary]
            limm.addEntriesFromDictionary([dicType : lim])
        }
        DataSourse = limm
        cacheSemester.addEntriesFromDictionary([self.type : self.classViewModel.allSemesters])
        cacheSemesterNum.addEntriesFromDictionary([self.type : self.classViewModel.semestersNum])
        cacheCourseData.addEntriesFromDictionary([self.type : limm])
    }
}
