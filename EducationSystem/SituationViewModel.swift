//
//  SituationViewModel.swift
//  EducationSystem
//
//  Created by Serx on 16/5/26.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import Foundation
import UIKit

struct CreditAndGrade {
    var credit: CGFloat!
    var grade: CGFloat!
}

class SituationViewModel {
    
    var userName: String!
    var passWord: String!
    
    var dataSourse: NSMutableDictionary!
    var allSemesters: [String]!
    var semesterNums: Int!
    
    /*
        all data

    */
    var courseDataSpecialized: Dictionary<String,[CreditAndGrade]> = [:]
    var courseDataPublic: Dictionary<String,[CreditAndGrade]> = [:]
    var courseDataNetwork: Dictionary<String,[CreditAndGrade]> = [:]
    
    var gpaTerm: [Double] = []
    var gpaTerm4: [Double] = []
    
    var scoreTerm: [Double] = []
    
    var gpa: Double = 0
    
    var gpa4: Double = 0
    
    var chinagpa: CGFloat = 0
    
    var scoreAverage: CGFloat = 0
    
    var creditSpecialized: CGFloat = 0
    
    var creditPublic: CGFloat = 0
    
    var creditNetwork: CGFloat = 0
    
    init() {
        // Initialize any variables if any
    }
    
}