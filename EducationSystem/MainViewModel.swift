//
//  MainViewModel.swift
//  EducationSystem
//
//  Created by Serx on 16/5/23.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import Foundation

class MainViewModel {
    
    var allCourse: [NSDictionary]!
    var studenInfo: NSDictionary!
    
    var urlString: String = "https://usth.eycia.me/Score"
    var userName: String!
    var passWord: String!
    
    var semestersNum: Int!
    var allSemesters = [String]()
    var courseDataSourse : [Dictionary<String, String>]!
    
    

    init() {
        // Initialize any variables if any
    }
}