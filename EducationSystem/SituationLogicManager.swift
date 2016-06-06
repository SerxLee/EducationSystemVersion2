//
//  SituationLogicManager.swift
//  EducationSystem
//
//  Created by Serx on 16/5/26.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//            2208701924 冯佳名 林中有  贺小飞

import UIKit

class SituationLogicManager: NSObject {
    
    let classViewModel: SituationViewModel
    
    var courseDataArray: [NSDictionary] = []
    
    override init() {
        self.classViewModel = SituationViewModel()
        super.init()
        //get all data
        self.getDataArrayFromCache()
        //
        self.getScoreAverage(false)
        //
        self.classViewModel.gpaTerm4 = self.getGPA(true)
        //
        self.classViewModel.gpaTerm = self.getGPA(false)
        //
        self.classViewModel.gpa4 = self.getGPADone(self.classViewModel.gpaTerm4)
        //
        self.classViewModel.gpa = self.getGPADone(self.classViewModel.gpaTerm)
        
//        self.calculation()
    }
    
    func checkCache(){
        let types = ["passing", "semester", "fail"]
        for type in types {
            if cacheCourseData[type] == nil || cacheSemesterNum[type] == nil || cacheSemester[type] == nil{
                //
            }
        }
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
                self.courseDataArray = currentTypeData["info"] as! [NSDictionary]
                let currentTypeSemesterCount = self.courseDataArray.count
                let currentTypeAllCourse = NSMutableDictionary()
                for dic in self.courseDataArray {
                    let currentSemesterTitle = dic["block_name"] as! String
                    //put all semester's title in 'allSemesters' array
                    currentTypeSemesters.append(currentSemesterTitle)
                    let currentSemesterCourse = dic["courses"] as! [NSDictionary]
                    currentTypeAllCourse.addEntriesFromDictionary([currentSemesterTitle : currentSemesterCourse])
                }
                cacheSemester.addEntriesFromDictionary([getType : currentTypeSemesters])
                cacheSemesterNum.addEntriesFromDictionary([getType : currentTypeSemesterCount])
                cacheCourseData.addEntriesFromDictionary([getType : currentTypeAllCourse])
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
    
    func calculation(){
        var courseNum: CGFloat = 0
        var totleScore: CGFloat = 0
        var totleCredit: CGFloat = 0
        
        self.classViewModel.dataSourse = cacheCourseData["passing"] as! NSMutableDictionary
        self.classViewModel.allSemesters = cacheSemester["passing"] as! [String]
        self.classViewModel.semesterNums = cacheSemesterNum["passing"] as! Int
        
        
        var lim: Int = 0
        var nian: Int = 0
        for i in 0 ..< self.classViewModel.allSemesters.count {
            lim += 1
            let semester =  self.classViewModel.allSemesters[self.classViewModel.allSemesters.count - 1 - i]
            print(semester)
            let currentSectionCourse: [Dictionary<String, String>] = self.classViewModel.dataSourse[semester] as! [Dictionary<String, String>]
            courseNum += CGFloat(currentSectionCourse.count)
            for course in currentSectionCourse {
                let attribute = course["type"]! as String
                if attribute == "必修" || attribute == "选修"{
                    let scoreString: String = course["score"]! as String                                                                
                    let scoreFloat: Float? = Float(scoreString)
                    let creditString: String = course["credit"]! as String
                    let creditFloat: Float? = Float(creditString)
//                    print(scoreFloat)
                    totleScore += (CGFloat(scoreFloat!) * CGFloat(creditFloat!))
                    totleCredit += CGFloat(creditFloat!)
                }
                else {
                    courseNum -= 1
                }
            }
            if lim % 2 == 0 {
                nian += 1
                let junfen: CGFloat = CGFloat(totleScore) / CGFloat(totleCredit)
                print(junfen)
            }
        }

        let junfen: CGFloat = CGFloat(totleScore) / CGFloat(totleCredit)
        print(junfen)
    }
    
    func getGPA(isFour: Bool) -> [Double] {
        var gpaTerm: [Double] = []
        var twoSemester: Int = 0
        if self.classViewModel.semesterNums % 2 == 0 {
            twoSemester = 0
        }
        else {
            twoSemester = 1
        }
        var header: CGFloat = 0
        var footer: CGFloat = 0.00000001
        for semester in self.classViewModel.allSemesters {
            //mark the it is the second semester in year
            twoSemester += 1
            
            let specializedCourse = self.classViewModel.courseDataSpecialized[semester]
            let publicCourse = self.classViewModel.courseDataPublic[semester]

            if isFour {
                //四分制计算GAP
                var fenzhi: CGFloat = 0
                for item in specializedCourse! {
                    fenzhi = self.getFenzhi(item.grade)
                    header += fenzhi * item.credit
                    footer += item.credit
                }
                for item in publicCourse! {
                    fenzhi = self.getFenzhi(item.grade)
                    header += fenzhi * item.credit
                    footer += item.credit
                }
            }
            else {
                //标准计算四分制
                for item in specializedCourse! {
                    header += item.grade * item.credit
                    footer += item.credit
                }
                for item in publicCourse! {
                    header += item.grade * item.credit
                    footer += item.credit
                }
            }
            if twoSemester == 2 {
                if isFour {
                    gpaTerm.append(Double(header / footer))
                }
                else {
                    gpaTerm.append(Double((header * 4.0) / (footer * 100)))
                }
                header = 0
                footer = 0.00000001
                twoSemester = 0
            }
        }
        return gpaTerm
    }
    
    func getFenzhi(grade: CGFloat) -> CGFloat {
        var fenzhi: CGFloat = 0
        if grade >= 90 {
            fenzhi = 4.0
        }
        else if grade >= 80 {
            fenzhi = 3.0
        }
        else if grade >= 70{
            fenzhi = 2.0
        }
        else if grade >= 60{
            fenzhi = 1.0
        }
        else {
            fenzhi = 0
        }
        return fenzhi
    }
    
    func getScoreAverage(isAllCourse: Bool){
        var allScore: CGFloat = 0
        var courseNum: CGFloat = 0.0000001
        var allScoreXCredit: CGFloat = 0
        
        
        var creditNet: CGFloat = 0
        var creditS: CGFloat = 0.0000001
        var creditp: CGFloat = 0.0000001
        
        var scoreTerm: [Double] = []
        for semester in self.classViewModel.allSemesters {
            var semesterAllScore: CGFloat = 0
            var semesterCourseNum: CGFloat = 0.0000001
            
            let specializedCourse = self.classViewModel.courseDataSpecialized[semester]
            let publicCourse = self.classViewModel.courseDataPublic[semester]
            let networkCourse = self.classViewModel.courseDataNetwork[semester]
            semesterCourseNum += (CGFloat(publicCourse!.count) + CGFloat(specializedCourse!.count))
            
            for item in specializedCourse! {
                creditS += item.credit
                semesterAllScore += item.grade
                allScoreXCredit += item.grade * item.credit
            }
            for item in publicCourse! {
                creditp += item.credit
                semesterAllScore += item.grade
                allScoreXCredit += item.grade * item.credit
            }
            for item in networkCourse! {
                if isAllCourse {
                    allScore += item.grade
                    courseNum += 1
                }
                creditNet += item.credit
            }
            courseNum += semesterCourseNum
            allScore += semesterAllScore
            scoreTerm.insert(Double(semesterAllScore / semesterCourseNum), atIndex: 0)
        }
        self.classViewModel.chinagpa = allScoreXCredit / (creditS + creditp)
        self.classViewModel.scoreTerm = scoreTerm
        self.classViewModel.scoreAverage = allScore / courseNum
        self.classViewModel.creditNetwork = creditNet
        self.classViewModel.creditPublic = creditp
        self.classViewModel.creditSpecialized = creditS
    }
    
    func getGPADone(gpas: [Double]) -> Double {
        var num = 0
        var t1: Double = 0
        for item in gpas {
            t1 += item
            num += 1
        }
        return t1 / Double(num)
        
    }
    
    func getDataArrayFromCache(){
        self.classViewModel.dataSourse = cacheCourseData["passing"] as! NSMutableDictionary
        self.classViewModel.allSemesters = cacheSemester["passing"] as! [String]
        self.classViewModel.semesterNums = cacheSemesterNum["passing"] as! Int
        

        for semester in self.classViewModel.allSemesters {
            var specializedArray: [CreditAndGrade] = []
            var publicArray: [CreditAndGrade] = []
            var networkArray: [CreditAndGrade] = []
            
            let currentSectionCourse: [Dictionary<String, String>] = self.classViewModel.dataSourse[semester] as! [Dictionary<String, String>]
            for course in currentSectionCourse{
                let creditStr: String = course["credit"]!
                let scoreStr: String = course["score"]!
                let attribute = course["type"]!
                let limcredit: Float? = Float(creditStr)
                let credit: CGFloat = CGFloat(limcredit!)
                let limscore: Float? = Float(scoreStr)
                let score: CGFloat = CGFloat(limscore!)
                let entity: CreditAndGrade = CreditAndGrade(credit: credit, grade: score)
                if attribute == "必修" {
                    specializedArray.append(entity)
                }
                else if attribute == "选修" {
                    publicArray.append(entity)
                }
                else if attribute == "任选" {
                    networkArray.append(entity)
                }
            }
            self.classViewModel.courseDataSpecialized[semester] = specializedArray
            self.classViewModel.courseDataPublic[semester] = publicArray
            self.classViewModel.courseDataNetwork[semester] = networkArray
        }
    }
}
