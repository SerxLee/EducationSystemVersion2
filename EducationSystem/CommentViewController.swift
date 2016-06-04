//
//  CommentViewController.swift
//  EducationSystem
//
//  Created by Serx on 16/5/26.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit
import Observable

class CommentViewController: UIViewController {

    var button: HamburgerButton! = nil
    
    var logicManager: CommentLogicManager = {return CommentLogicManager()}()
    var classViewModel: CommentViewModel!
    
    var className: String!
    var headerZoomView: UIImageView!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    @IBOutlet weak var leftBarButton: UIBarButtonItem!

    //the reply action, the operation indexPath
    private var commentOperatingIndexPaths: NSIndexPath?
    //the digg action, the operation indexPath
    private var likeOperatingIndexPaths: NSIndexPath?
    private var isNewComment: Bool = false
    
    // 假评论输入框
    lazy private var fakeCommentInputField: UITextField = {
        let fakeTextField = UITextField(frame: CGRectZero)
        fakeTextField.inputAccessoryView = self.fakeCommentInputFieldAccessoryView
        return fakeTextField
    }()
    
    lazy private var fakeCommentInputFieldAccessoryView: UIView = {
        let inputAccessoryView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds), 44))
        inputAccessoryView.backgroundColor = UIColor(white: 0.91, alpha: 1)
        
        let commentTextField = self.realCommentInputField
        inputAccessoryView.addSubview(commentTextField)
        
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        
        inputAccessoryView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[commentTextField]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["commentTextField" : commentTextField]))
        inputAccessoryView.addConstraint(NSLayoutConstraint(item: commentTextField, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: inputAccessoryView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        
        return inputAccessoryView
    }()
    
    // 真正的评论输入框
    lazy private var realCommentInputField: UITextField = {
        let commentInputField = UITextField()
        commentInputField.delegate = self
        commentInputField.returnKeyType = UIReturnKeyType.Send;
        commentInputField.spellCheckingType = UITextSpellCheckingType.No
        commentInputField.autocorrectionType = UITextAutocorrectionType.No
        commentInputField.borderStyle = UITextBorderStyle.RoundedRect
        return commentInputField
    }()
    
    override func viewDidLoad() {
        self.classViewModel = self.logicManager.classViewModel
        self.logicManager.courseName = self.className
        //MARK: load the local data
        self.logicManager.getData(true)
//        self.logicManager.loadDataFromLocal()
        super.viewDidLoad()
        self.initView()
        
//        //MARK: CREATE a button
//        self.button = HamburgerButton(frame: CGRectMake(133, 133, 54, 54))
//        self.button.addTarget(self, action: #selector(self.toggle(_:)), forControlEvents:.TouchUpInside)
//        self.button.tintColor = themeColor
//        self.view.addSubview(button)
    }
    
    func toggle(sender: AnyObject!) {
        self.button.showsMenu = !self.button.showsMenu
    }
    
    func initView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        self.tableView.tableFooterView = UIView.init()
        self.tableView.backgroundColor = UIColor.clearColor()
//        self.view.backgroundColor = themeColor
        /**
            add the textfield to te table view , 
                if not . the real comment text field will not found
        */
        self.tableView.addSubview(fakeCommentInputField)
        
        self.navigationController?.navigationBar.lt_setBackgroundColor(themeColor.colorWithAlphaComponent(0.0))
        //定义渐变的颜色，多色渐变太魔性了，我们就用两种颜色
        let topColor = themeColor
        let buttomColor = UIColor.whiteColor()
        //将颜色和颜色的位置定义在数组内
        let gradientColors: [CGColor] = [topColor.CGColor, buttomColor.CGColor]
        let gradientLocations: [CGFloat] = [0.0, 1.0]
        
        //创建CAGradientLayer实例并设置参数
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        //设置其frame以及插入view的layer
        gradientLayer.frame = CGRectMake(0, 0, MasterViewController.getUIScreenSize(true), MasterViewController.getUIScreenSize(false) / 4.0)
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        //set navigation bar
        let img = UIImage(named: "editImage")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.rightBarButton.image = img
        self.rightBarButton.style = .Plain
        
        let img2 = UIImage(named: "backImage")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.leftBarButton.image = img2
        self.leftBarButton.style = .Plain
        
        /*
            3 number states:
                1: just change
                2: upload success
                3: upload fail
        */
        self.classViewModel.newCommentUploadState.afterChange += { old, new in
            if new == 1 {
                self.afterUploadComment()
            }
            else if new == 2 {
                // notise the user , public success
            }
            else if new == 3 {
                self.afterUploadComment()
                //notise the user , public fail
            }
        }
        self.classViewModel.diggUploadState.afterChange += { old, new in
            if new == 1 {
                self.afterUploadDigged()
            }
            else if new == 2 {
                // notise the user , digged success
            }
            else if new == 3{
                self.afterUploadDigged()
                //notise the user , digged fail
            }
        }
        self.classViewModel.getCommentState.afterChange += { old, new in
            if new == 1 {
                self.afterUploadComment()
                NSLog("get comment success")
            }
            else if new == 2 {
                //data sourse is null
            }
            else if new == 3 {
                //the network is error
            }
        }
    }
    
    func afterUploadComment(){
        dispatch_async(dispatch_get_main_queue()) { 
            self.tableView.reloadData()
            self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
        }
    }
    
    func afterUploadDigged(){
        dispatch_async(dispatch_get_main_queue()) { 
            self.tableView.reloadRowsAtIndexPaths([self.likeOperatingIndexPaths!], withRowAnimation: UITableViewRowAnimation.None)
        }
    }
    
    func handleReplyOperation(){
        NSLog("click the reply comment")
        let commentOperatingIndexPath = self.commentOperatingIndexPaths
        if commentOperatingIndexPath != nil && self.classViewModel.dataSourse.count > commentOperatingIndexPath!.row {
            if fakeCommentInputField.becomeFirstResponder() {
                ///set the textfile place holder
                let replyedName = self.classViewModel.dataSourse[(commentOperatingIndexPath?.row)!]["authorName"] as! String
                realCommentInputField.placeholder = "回复 \(replyedName)"
                realCommentInputField.becomeFirstResponder()
            }
        }
    }
    
    func handleLikeOperation(){
        NSLog("click the like button")
        let likeOperatingIndexPath = self.likeOperatingIndexPaths
        if likeOperatingIndexPath != nil && self.classViewModel.dataSourse.count > likeOperatingIndexPath!.row {
            //MARK: sent to logic manager handle
            self.logicManager.handleLikeOperation(likeOperatingIndexPath!.row)
        }
    }
    
    /**
        the method to 'resignFirstResponder' fack and real inputTextField
     */
    private func commentFiledResignFirstResponder() {
        if realCommentInputField.isFirstResponder() {
            realCommentInputField.resignFirstResponder()
        }
        if fakeCommentInputField.isFirstResponder() {
            fakeCommentInputField.resignFirstResponder()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func leftBarItemAction(sender: AnyObject) {
//        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //handle the new commment
    @IBAction func rightBarItemAction(sender: AnyObject) {
        //TODO: edit a new comment
        if fakeCommentInputField.becomeFirstResponder() {
            realCommentInputField.placeholder = ""
            realCommentInputField.becomeFirstResponder()
        }
        //set it is new comment 
        self.isNewComment = true
    }
}

extension CommentViewController: CommentTableViewCellDelegate {
    func commentCell(commentCell: CommentTVCell, didClickReplyButton: UIButton) {
        let commentCellIndexPath = tableView.indexPathForRowAtPoint(tableView.convertPoint(CGPointZero, fromView: commentCell))
        self.commentOperatingIndexPaths = commentCellIndexPath
        self.isNewComment = false
        self.handleReplyOperation()
    }
    
    func commentCell(commentCell: CommentTVCell, didClickLikeButton: UIButton) {
        let likeCellIndexPath = tableView.indexPathForRowAtPoint(tableView.convertPoint(CGPointZero, fromView: commentCell))
        self.likeOperatingIndexPaths = likeCellIndexPath
        self.handleLikeOperation()
    }
}

extension CommentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == realCommentInputField {
            commentFiledResignFirstResponder()
            let commentText = textField.text!
            ///TODO: the comment text lenght is not allowed to be over 140!!!!!
            if commentText == "" {
                let alert = UIAlertController(title: nil, message: "请输入评论内容", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "确定", style: .Default, handler: { (nil) in
                    if self.fakeCommentInputField.becomeFirstResponder() {
                        self.realCommentInputField.becomeFirstResponder()
                    }
                })
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
                return false
            }
            //MARK: if the comment text is not nil, sent to logic manager handle
            else {
                var row = self.commentOperatingIndexPaths?.row
                if isNewComment {
                    print(row)
                    row = nil
                }
                self.logicManager.handleCommentPublic(commentText, isNewComment: isNewComment, getRow: row)
            }
        }
        textField.text = ""
        return true
    }
}

extension CommentViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

extension CommentViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classViewModel.dataSourse.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CommentTVCell.cellHeightWithData(self.classViewModel.dataSourse[indexPath.row], cellWidth: CGRectGetWidth(tableView.bounds))
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier: String = "myCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! CommentTVCell
        let row = indexPath.row
        cell.showTopSeperator = (row != 0)
        cell.delegate = self
        let indexPathSource = self.classViewModel.dataSourse[indexPath.row] as? [String : AnyObject]
        cell.configWithData(indexPathSource, cellWidth: CGRectGetWidth(tableView.bounds))
        return cell
    }
}


