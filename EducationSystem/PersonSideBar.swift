//
//  PersonSideBar.swift
//  EducationSystem
//
//  Created by Serx on 16/5/29.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit
import Masonry
import AFNetworking
import Qiniu
import HappyDNS
import Kingfisher
import Foundation
import Observable
import SnapKit


public let rawWidth = UIScreen.mainScreen().bounds.width
public let rawHeight = UIScreen.mainScreen().bounds.height
public let kNavHieght = 64

public var masterImageChange: Observable<Int> = Observable(1)

class PersonSideBar: UIView {
    
    var zoomImageView:UIImageView!
    var headImageView:UIImageView!
    var userName:UILabel!
    var backgroundView:UIView!
    var tableView:UITableView!
    var cancelButton: UIButton!
    var footerView: UIView!
    
    
    var userHeadImageURL: String = studentInfo!["head"] as! String
    let imageFileName: String = "image1"
    var hadChangeImage: Bool = false
    
    var isSelectedHeader = false
    
    let color: UIColor = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
    
    let tokenURL: String = "https://usth.eycia.me/head/getToken"
    var token: String!
    var userKey: String!
    
    var barWidth: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = self.color
        
        barWidth = rawWidth - rawWidth / 4
        let rect = CGRectMake(-barWidth, 0, barWidth, rawHeight)
        
        self.backgroundView = UIImageView(frame: rect)
        self.backgroundView.userInteractionEnabled = true
        self.addSubview(self.backgroundView)

        self.tableView = UITableView.init(frame: CGRectMake(0, 0, barWidth, rawHeight), style: .Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.tableFooterView = UIView.init()
        self.backgroundView.addSubview(self.tableView)
        self.tableView.contentInset.top = 160
        self.tableView.separatorStyle = .None
        self.tableView.scrollEnabled = false
        
//        self.footerView = UIImageView()
//        self.footerView.backgroundColor = UIColor.whiteColor()
//        self.footerView.frame = CGRectMake(0, rawHeight - 40, barWidth, 40)
//        self.footerView.contentMode = .ScaleAspectFill
//        self.backgroundView.addSubview(footerView)
//        self.footerView.autoresizesSubviews = true
        
        self.cancelButton = UIButton(type: UIButtonType.System)
//        self.cancelButton.frame = CGRectMake(0, rawHeight - 40, barWidth, 40)
        self.cancelButton.setTitle("注销登录", forState: UIControlState.Normal)
        self.cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.cancelButton.titleLabel?.textAlignment = NSTextAlignment.Right
        self.cancelButton.addTarget(self, action: #selector(PersonSideBar.cancelLoginButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.backgroundView.addSubview(cancelButton)
        self.cancelButton.backgroundColor = UIColor.redColor()
        self.cancelButton.layer.cornerRadius = 5.0
        self.cancelButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.tableView)
            make.width.equalTo(100)
            make.height.equalTo(25)
            make.bottom.equalTo(-5)
        }
        
        self.zoomImageView = UIImageView()
        self.zoomImageView.backgroundColor = themeColor
        self.zoomImageView.frame = CGRectMake(0, -160, barWidth, 160)
        self.zoomImageView.contentMode = .ScaleAspectFill
        self.tableView.addSubview(self.zoomImageView)
        self.zoomImageView.autoresizesSubviews = true
        
        let headH:CGFloat = 80
        let headY:CGFloat = (160 - headH)/2
        let headX:CGFloat = (barWidth - headH)/2
        self.headImageView = UIImageView()
        self.loadUserImage()                    // if the image is exit, load via the cache
        self.headImageView.frame = CGRectMake(headX, headY, headH, headH)
        self.headImageView.clipsToBounds = true
        self.headImageView.layer.cornerRadius = headH / 2
        self.headImageView.autoresizingMask = .FlexibleTopMargin
        self.zoomImageView.addSubview(self.headImageView)
        
        self.userName = UILabel.init(frame: CGRectMake(0, headY + headH + 10, barWidth, 20))
        self.userName.text = studentInfo!["name"] as? String
        self.userName.textColor = UIColor.whiteColor()
        self.userName.textAlignment = NSTextAlignment.Center
        self.userName.font = UIFont.systemFontOfSize(14)
        self.userName.autoresizingMask = .FlexibleTopMargin
        self.zoomImageView.addSubview(self.userName)
        
        let tapImageView = UITapGestureRecognizer.init(target: self, action: #selector(PersonSideBar.headImageViewClick(_:)))
        self.zoomImageView.userInteractionEnabled = true
        self.zoomImageView.addGestureRecognizer(tapImageView)
        
        let taps = UITapGestureRecognizer.init(target: self, action: #selector(PersonSideBar.dismissClick(_:)))
        taps.delegate = self
        self.addGestureRecognizer(taps)
        
        let slideLeft = UISwipeGestureRecognizer(target: self, action: #selector(PersonSideBar.dismissClick(_:)))
        slideLeft.direction = .Left
        self.tableView.addGestureRecognizer(slideLeft)
    }
    
    func loadUserImage() {
        if userHeadImageURL != ""{
            let url: NSURL = NSURL(string: self.userHeadImageURL)!
            self.headImageView.kf_setImageWithURL(url)
        }
        else {
            self.headImageView.image = UIImage(named: "defaultImage")
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if touch.view == self {
            return true
        } else if (touch.view == self.zoomImageView) {
            return true
        }
        return false
    }
    
    //MARK: cancel the login
    func cancelLoginButtonClick(button: UIButton) {
        NSLog("click cancel button")
        self.cancelLoginAlert()
    }
    func cancelLoginAlert() {
        let notionAlert = UIAlertController(title: "请确认操作", message: "", preferredStyle: .Alert)
        let cancelOption = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let confirmOption = UIAlertAction(title: "确定", style: .Default, handler: cancelLogin)
        notionAlert.addAction(confirmOption)
        notionAlert.addAction(cancelOption)
        let currentController = self.getCurrentViewController()
        currentController?.presentViewController(notionAlert, animated: true, completion: nil)
    }
    
    
    func cancelLogin(ac: UIAlertAction) -> Void{
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyBoard.instantiateViewControllerWithIdentifier("NewLoginViewController")
        self.window?.rootViewController = loginVC
    }
    
    //MARK: set let the user image
    func headImageViewClick(gesture: UITapGestureRecognizer) {
        NSLog("click user image")
        self.getToken()
        self.selectIcon()
    }
    
    func selectIcon(){
        self.isSelectedHeader = true
        let userIconAlert = UIAlertController(title: "更换头像", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let chooseFromPhotoAlbum = UIAlertAction(title: "从相册选择", style: UIAlertActionStyle.Default, handler: funcChooseFromPhotoAlbum)
        userIconAlert.addAction(chooseFromPhotoAlbum)
        let chooseFromCamera = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default,handler:funcChooseFromCamera)
        userIconAlert.addAction(chooseFromCamera)
        let canelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler: nil)
        userIconAlert.addAction(canelAction)
        let currentController = self.getCurrentViewController()
        currentController?.presentViewController(userIconAlert, animated: true, completion: nil)
    }
    
    func getCurrentViewController() -> UIViewController? {
        if let rootController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
                currentController.navigationController?.navigationBar.lt_setBackgroundColor(self.color)
            }
            return currentController
        }
        return nil
    }
    
    func funcChooseFromPhotoAlbum(avc:UIAlertAction) -> Void{
        let imagePicker = UIImagePickerController()
        imagePicker.navigationBar.translucent = true
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //present to library IamgePickerView
        let currentController = self.getCurrentViewController()
        currentController?.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func funcChooseFromCamera(avc:UIAlertAction) -> Void{
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing=true
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        //present to camera IamgePickerView
        let currentController = self.getCurrentViewController()
        currentController?.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dismissClick(gesture:UIGestureRecognizer) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.backgroundView.frame = CGRectMake(-self.backgroundView.frame.size.width, self.backgroundView.frame.origin.y, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height)
        }) { (finshed) -> Void in
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.alpha = 0
            })
        }
    }
    
    
    func showPersonal() {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.alpha = 1
        }) { (finshed) -> Void in
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.backgroundView.frame = CGRectMake(0, self.backgroundView.frame.origin.y, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height)
            })
        }
    }
    func showPersionalViaDrag(point: CGPoint) {
        if self.alpha == 0{
            UIView.animateWithDuration(0.1) {
                self.alpha = 1
            }
        }
        else {
            if point.x - barWidth > -20{
                self.showPersonal()
            }
            else {
                self.backgroundView.frame = CGRectMake(-barWidth + point.x, self.backgroundView.frame.origin.y, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height)
            }
        }
    }
    
    func dragSideBarEnd(){
        let currentWidth = self.backgroundView.frame.origin.x
        if currentWidth < (-barWidth / 2) {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.backgroundView.frame = CGRectMake(-self.backgroundView.frame.size.width, self.backgroundView.frame.origin.y, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height)
            }) { (finshed) -> Void in
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.alpha = 0
                })
            }
        }
        else {
            self.showPersonal()
        }
    }
    
    func getToken(){
        loginSession.GET(tokenURL, parameters: nil, success: { (dataTask, respons) in
            let err = respons["err"] as! Int
            if err == 0 {
                self.token = respons["data"] as! String
                print(self.token)
            }
            else {
                let reason = respons["reason"] as! String
                NSLog(reason)
            }
        }) { (dataTask, error) in
            NSLog("netWork error while get token")
            print(error)
        }
    }
    
    //click clean history data cell
    func notionWhileClean() {
        let notionAlert = UIAlertController(title: "请确认操作", message: "", preferredStyle: .Alert)
        let cancelOption = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let confirmOption = UIAlertAction(title: "确定", style: .Default) { (nil) in
            let historyDataModel = HistoryDataModel()
            historyDataModel.dataRead(true)
        }
        notionAlert.addAction(confirmOption)
        notionAlert.addAction(cancelOption)
        let currentController = self.getCurrentViewController()
        currentController?.presentViewController(notionAlert, animated: true, completion: nil)
    }
    
    func gotoCommentViaSideBar() {
        let currentController = getCurrentViewController()
        let alert = UIAlertController(title: "", message: "Enter course number", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "前往", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            let str = textField.text!
            if str != "" {
                let commentController = CommentViewController()
                commentController.className = str
                currentController?.navigationController?.pushViewController(commentController, animated: true)
            }
        }))
        
        // 4. Present the alert.
        currentController!.presentViewController(alert, animated: true, completion: nil)
    }
    
    func selectedBackgroundImage(){
        self.isSelectedHeader = false
        let userIconAlert = UIAlertController(title: "更换背景", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let chooseFromPhotoAlbum = UIAlertAction(title: "从相册选择", style: UIAlertActionStyle.Default, handler: funcChooseFromPhotoAlbum)
        userIconAlert.addAction(chooseFromPhotoAlbum)
        let chooseFromCamera = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default,handler:funcChooseFromCamera)
        userIconAlert.addAction(chooseFromCamera)
        let canelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler: nil)
        userIconAlert.addAction(canelAction)
        let currentController = self.getCurrentViewController()
        currentController?.presentViewController(userIconAlert, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //UITableViewDelegate
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
}

// up load to qi niu
extension PersonSideBar: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = (info as NSDictionary).objectForKey(UIImagePickerControllerEditedImage)
        
        if self.isSelectedHeader {
            uploadWithName(imageFileName, content: image as! UIImage)
        }
        else {
            self.saveImage(image as! UIImage, imageName: imageFileName)
//            let fullPath = ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent(imageFileName)
//            let savedImage = UIImage(contentsOfFile: fullPath)
//            let controller = self.getCurrentViewController() as! MasterViewController
//            controller.viewHeaderImage.image = savedImage
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.backgroundView.frame = CGRectMake(-self.backgroundView.frame.size.width, self.backgroundView.frame.origin.y, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height)
            }) { (finshed) -> Void in
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.alpha = 0
                })
            }
            /** transaction to masterView */
            masterImageChange <- (0 - masterImageChange.value)
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveImage(currentImage: UIImage,imageName: String){
        
        var imageData = NSData()
        imageData = UIImageJPEGRepresentation(currentImage, 0.5)!
        let fullPath = ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent(imageName)
        imageData.writeToFile(fullPath, atomically: false)
    }
    
    func uploadWithName(fileName: String, content: UIImage) {
        
        let newImage: UIImage = content.imageByScalingAndCroppingForSize(CGSizeMake(100, 100))
        let myData = UIImagePNGRepresentation(newImage)
        // 如果覆盖已有的文件，则指定文件名。否则如果同名文件已存在，会上传失败
        let uploader: QNUploadManager = QNUploadManager()
        uploader.putData(myData, key: self.userKey, token: self.token, complete: { (info: QNResponseInfo!, key: String!, resp: [NSObject : AnyObject]!) -> Void in
            if info.ok {
                NSLog("Success")
//                print(info)
                print(resp)
                let err = resp["err"] as! Int
                if err == 0 {
                    self.userHeadImageURL = resp["data"] as! String
                    print("change success")
                    NSThread.sleepForTimeInterval(2.0)
                    //get back the main queue and update the userImage
                    dispatch_async(dispatch_get_main_queue(), {
                        self.loadUserImage()
                    })
                    ///update head in studentInfo
                    let limStudentInfo: NSMutableDictionary = NSMutableDictionary(dictionary: studentInfo!)
                    limStudentInfo["head"] = self.userHeadImageURL
                    studentInfo = NSDictionary(dictionary: limStudentInfo)
                }
                else {
                    print(resp["reason"] as! String)
                }
            } else {
                NSLog("Error: " + info.error.description)
            }
            }, option: nil)
    }
}


extension PersonSideBar: UITableViewDelegate{
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        if y < -160 {
            var frame = self.zoomImageView.frame
            frame.origin.y = y
            frame.size.height = -y
            self.zoomImageView.frame = frame
        }	
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 1 {
            let row = indexPath.row
//            if row == 0 {
//                
//            }
//            //

//            else
            if row == 1 {
                self.notionWhileClean()
            }
            else if row == 0 {
                self.selectedBackgroundImage()
            }
        }
    }
}

extension PersonSideBar: UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        else {
            return 2
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String = ""
        if section == 0 {
            title = "基本信息"
        }
        else if section == 1 {
            title = "其他操作"
        }
        return title
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: "cell")
        }
        let sectionOfIndex = indexPath.section
        let row = indexPath.row
        var lableText: String! = ""
        if sectionOfIndex == 0 {
            ///set the cell enable to be selected
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            if row == 0 {
                lableText = "    \(studentInfo!["class"] as! String)"
            }
            else {
                lableText = "    \(studentInfo!["stu_id"] as! String)"
            }
        }
        else if sectionOfIndex == 1 {
//            if row == 0 {
//                lableText = "    前往某评论区"
//            }
//            else
            if row == 1 {
                lableText = "    清理缓存"
            }
            else if row == 0 {
                lableText = "    更改封面图"
            }

        }
        cell?.textLabel?.text = lableText
        return cell!
    }
}

extension PersonSideBar: UIGestureRecognizerDelegate{
    
}
