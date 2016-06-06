//
//  CommentLogicManager.swift
//  EducationSystem
//
//  Created by Serx on 16/5/26.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit
import Observable

class CommentLogicManager: NSObject {
    
    let classViewModel: CommentViewModel
    
    //get from last controler view
    var courseName: String = "testclass"
    
    //be used to get more comment's url
    var timeLast: Int = -1
    var idLast: String = "0"
    
    var isFirst: Bool = true
    
    override init() {
        self.classViewModel = CommentViewModel()
        super.init()
//        self.loadDataFromLocal()
    }
    
    func getData() {
        if self.isFirst {
            self.timeLast = -1
            self.idLast = "0"
        }
        else {
            NSLog("in here")
            let lastComment = self.classViewModel.dataSourse.last!
            self.timeLast = lastComment["time"] as! Int
            self.idLast = lastComment["id"] as! String
        }
        
        let URL = "https://usth.eycia.me/Reply/course/\(courseName)/20/\(idLast)/\(timeLast)"
        loginSession.GET(URL, parameters: nil, success: { (dataTask, response) in
            let err = response["err"] as! Int
            if err == 0 {
//                self.classViewModel.dataSourse = response["data"] as! [NSDictionary]
                let limDataSourse: [NSDictionary] = response["data"] as! [NSDictionary]
                //TODO: should observer
                if limDataSourse.isEmpty {
                    // there is new data , notise
                    if self.isFirst {
                        //there is not comments
                        self.classViewModel.getCommentState <- 4
                    }
                    else {
                        //there is not more comment
                        self.classViewModel.getCommentState <- 2
                    }
                }
                else {
                    self.classViewModel.dataSourse.insertContentsOf(limDataSourse, at: self.classViewModel.dataSourse.count)
                    self.classViewModel.getCommentState <- 1
                    print(limDataSourse)
                }
            }
            else {
                let reason: String = response["reason"] as! String
                NSLog(reason)
                self.classViewModel.getCommentState <- 3
            }
            }) { (dataTask, error) in
                NSLog("error when get the comment data: \(error)")
                self.classViewModel.getCommentState <- 3
        }
    }
    
    func createOneNewComment(commentText: String, isNewComment: Bool, refeRow: Int?) -> NSDictionary{
        var newDic = NSDictionary()
        
        var authorName: AnyObject = ""
        var stuId:AnyObject = ""
        var content: AnyObject = ""
        
        var RefedAuthorId: AnyObject = ""
        var refedAuthor: AnyObject = ""
        var refedContent: AnyObject = ""
        var refId: AnyObject = "0"
        
        let digg: AnyObject = 0
        var className: AnyObject = ""
        var time: AnyObject = 0
        let digged: AnyObject = false
        let id: AnyObject = "0"
        
        var header = studentInfo!["head"]
        if header == nil {
            header = ""
        }
        //FIXME: add user image
        authorName = studentInfo!["name"]!
        stuId = studentInfo!["stu_id"]!
        content = commentText
        time = NSDate().timeIntervalSince1970
        if !isNewComment {
            if let row = refeRow {
                let refeDic: NSDictionary = self.classViewModel.dataSourse[row]
                RefedAuthorId = refeDic["id"]!
                refedAuthor = refeDic["authorName"]!
                refedContent = refeDic["content"]!
                refId = refeDic["id"]!
                className = refeDic["className"]!
            }
        }
        newDic = ["refedAuthor": refedAuthor, "content": content, "id": id, "time": time, "digged": digged, "authorName": authorName, "className": className, "refedContent": refedContent, "RefedAuthorId": RefedAuthorId, "digg": digg, "refId": refId, "stuId": stuId, "head": header!]
        
        return newDic
    }
    
    func handleCommentPublic(commentText: String, isNewComment: Bool, getRow: Int?) {
        ///handle new comment
        
        var newComment: NSDictionary = createOneNewComment(commentText, isNewComment: isNewComment, refeRow: getRow)
        //FIXME: notise the table view reload
        var URL = "https://usth.eycia.me/Reply/course/\(self.courseName)"
        if isNewComment {
            //
        }
        else {
            let row = getRow!
            let refeDic: NSDictionary = self.classViewModel.dataSourse[row]
            
            let refId = refeDic["id"]!
            
            URL = "https://usth.eycia.me/Reply/course/\(self.courseName)/\(refId)/reply"
        }
        self.classViewModel.dataSourse.insert(newComment, atIndex: 0)
        self.classViewModel.newCommentUploadState <- 1
        let parameters: Dictionary<String, String> = ["content": commentText]
        loginSession.POST(URL, parameters: parameters, success: { (dataTask, response) in
            let err = response["err"] as! Int
            if err == 0 {
                //MARK: get the reback id, and add it into the data sourse
                let id: String = response["data"] as! String
                let mutableDic = NSMutableDictionary(dictionary: newComment)
                mutableDic["id"] = id
                newComment = NSDictionary(dictionary: mutableDic)
                self.classViewModel.dataSourse.removeFirst()
                self.classViewModel.dataSourse.insert(newComment, atIndex: 0)
                //TODO: notise the tableView Reload
                self.classViewModel.newCommentUploadState <- 2
            }
            else {
                let reason: String = response["reason"] as! String
                NSLog(reason)
                self.classViewModel.dataSourse.removeFirst()
                //FIXME: remove the first data in data sourse, and notise tableview reload
                self.classViewModel.newCommentUploadState <- 3
            }
            }) { (dataTask, error) in
                NSLog("it is error when push new comment to sever: \(error.localizedDescription)")
                
                self.classViewModel.dataSourse.removeFirst()
                //FIXME: remove the first data in data sourse, and notise tableview reload
                self.classViewModel.newCommentUploadState <- 3
        }
    }
    
    func handleLikeOperation(row: Int) {
        let operateComment = self.classViewModel.dataSourse[row] as! Dictionary<String, AnyObject>
        let diggedID = operateComment["id"] as! String
        let addDiggURL = "https://usth.eycia.me/Reply/\(diggedID)/digg/add"
        var currentComment = operateComment
        if currentComment["digged"] as! Bool == false {
            currentComment["digged"] = true
            currentComment["digg"] = currentComment["digg"] as! Int + 1
            self.classViewModel.dataSourse[row] = currentComment
            //FIXME: to noties reload the row in table view
            self.classViewModel.diggUploadState <- 1
            loginSession.POST(addDiggURL, parameters: nil, success: { (dataTask, response) in
                
                let err = response["err"] as! Int
                
                if err == 0 {
                    ///TODO:  notice the user dig success
                    self.classViewModel.diggUploadState <- 2
                }
                else {
                    let reason: String = response["reason"] as! String
                    NSLog("fail while upload the digg")
                    NSLog(reason)
                    ///fail, change the dataSource to old state
                    currentComment["digged"] = false
                    currentComment["digg"] = currentComment["digg"] as! Int - 1
                    self.classViewModel.dataSourse[row] = currentComment
                    //FIXME: dig fail ,to noties reload the row in table view
                    self.classViewModel.diggUploadState <- 3
                }
                }, failure: { (dataTask, error) in
                    NSLog("the network is error while dig comment: \(error.localizedDescription)")
                    
                    currentComment["digged"] = false
                    currentComment["digg"] = currentComment["digg"] as! Int - 1
                    self.classViewModel.dataSourse[row] = currentComment
                    //FIXME: dig fail ,to noties reload the row in table view
                    self.classViewModel.diggUploadState <- 3
            })
        }
    }
    
    func loadDataFromLocal(){
        let response: NSDictionary = NSDictionary.loadJSONFromBundle()!
        self.classViewModel.dataSourse = response["data"] as! [NSDictionary]
    }
}
