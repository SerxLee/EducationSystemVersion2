//
//  CommentViewModel.swift
//  EducationSystem
//
//  Created by Serx on 16/5/26.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import Foundation
import UIKit
import Observable

class CommentViewModel {
    
    //save the comment's value
    var dataSourse: [NSDictionary]!
    
    //upload state observation
    var diggUploadState: Observable<Int> = Observable(0)
    var newCommentUploadState: Observable<Int> = Observable(0)
    var getCommentState: Observable<Int> = Observable(0)
    
    init() {
        // Initialize any variables if any
        self.dataSourse = []
    }
}