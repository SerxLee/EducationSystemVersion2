//
//  MasterViewModel.swift
//  EducationSystem
//
//  Created by Serx on 16/5/25.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import Foundation
import UIKit
import Observable

var cacheState: Observable<Int> = Observable(0)

class MasterViewModel {
    
    var courseDataArray: [NSDictionary]?
    var studentInfo: NSDictionary?
    
    var urlString: String = "https://usth.eycia.me/Score"
    var userName: String! = ""
    var passWord: String! = ""
    
    var showSearch: Bool = false
    
    var semestersNum: Int!
    var allSemesters = [String]()
    var courseDataSourse : [Dictionary<String, String>]!
    
    init() {
        // Initialize any variables if any
    }
}