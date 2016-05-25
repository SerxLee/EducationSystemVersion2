//
//  LoginViewModel.swift
//  EducationSystem
//
//  Created by Serx on 16/5/23.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import Foundation
import AFNetworking
import Observable


class LoginViewModel {
    
    var deviceHeight: CGFloat = 0.0
    var deviceWidth: CGFloat = 0.0
    
    let checkURL: String = "https://usth.eycia.me/Score"

    var matchResultArray: [String] = []
    var historyArray: [String] = []
    
    var courseDataArray: [NSDictionary]?
    var studentInfo: NSDictionary?
    
    init() {
        // Initialize any variables if any
        LoginViewModel.initAllPublicCache()
    }
    
    //Inti all the 'Public' data of cache
    static func initAllPublicCache(){
        cacheSemester.removeAllObjects()
        cacheCourseData.removeAllObjects()
        cacheSemesterNum.removeAllObjects()
    }
}
