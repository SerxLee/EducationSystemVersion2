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


public let rawWidth = UIScreen.mainScreen().bounds.width
public let rawHeight = UIScreen.mainScreen().bounds.height
public let kNavHieght = 64

class PersonSideBar: UIView {
    
    var zoomImageView:UIImageView!
    var headImageView:UIImageView!
    var userName:UILabel!
    var backgroundView:UIView!
    var tableView:UITableView!
    var cancelButton: UIButton!
    var footerView: UIView!
    
    
    var userHeadImageURL: String = studentInfo!["head"] as! String
    let imageFileName: String = "myHead"
    var hadChangeImage: Bool = false
    
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

        self.tableView = UITableView.init(frame: CGRectMake(0, 0, barWidth, rawHeight - 40), style: .Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.tableFooterView = UIView.init()
        self.backgroundView.addSubview(self.tableView)
        self.tableView.contentInset.top = 160
        
        self.footerView = UIImageView()
        self.footerView.backgroundColor = UIColor.whiteColor()
        self.footerView.frame = CGRectMake(0, rawHeight - 40, barWidth, 40)
        self.footerView.contentMode = .ScaleAspectFill
        self.backgroundView.addSubview(footerView)
        self.footerView.autoresizesSubviews = true
        
        self.cancelButton = UIButton(type: UIButtonType.System)
        self.cancelButton.frame = CGRectMake(0, rawHeight - 40, barWidth, 40)
        self.cancelButton.setTitle("注销登录", forState: UIControlState.Normal)
        self.cancelButton.titleLabel?.textAlignment = NSTextAlignment.Right
        self.cancelButton.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0)
        self.backgroundView.addSubview(cancelButton)
        
        self.zoomImageView = UIImageView()
        self.zoomImageView.backgroundColor = UIColor(red: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)
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
        
        self.cancelButton.addTarget(self, action: #selector(PersonSideBar.cancelLoginButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func loadUserImage() {
        if userHeadImageURL != ""{
            let url: NSURL = NSURL(string: self.userHeadImageURL)!
            self.headImageView.setImageWithURL(url, placeholderImage: UIImage(named: "defaultImage")!)
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
        let loginVC = storyBoard.instantiateViewControllerWithIdentifier("LoginViewController")
        self.window?.rootViewController = loginVC
    }
    
    //MARK: set let the user image
    func headImageViewClick(gesture: UITapGestureRecognizer) {
        NSLog("click user image")
        self.getToken()
        self.selectIcon()
    }
    
    func selectIcon(){
        let userIconAlert = UIAlertController(title: "请选择操作", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
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
    
    func getToken(){
        loginSession.GET(tokenURL, parameters: nil, success: { (dataTask, respons) in
            let err = respons["err"] as! Int
            if err == 0 {
                self.token = respons["data"] as! String
                print(self.token)

            }
        }) { (dataTask, error) in
            print(error)
        }
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

extension PersonSideBar: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = (info as NSDictionary).objectForKey(UIImagePickerControllerEditedImage)
        
//        self.saveImage(image as! UIImage, imageName: imageFileName)
//        let fullPath = ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent(imageFileName)
        
//        let savedImage = UIImage(contentsOfFile: fullPath)
        uploadWithName(imageFileName, content: image as! UIImage)
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
                    //get back the main queue and update the userImage
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.loadUserImage()
                    })
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
}

extension PersonSideBar: UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: "cell")
        }
        if indexPath.row == 0 {
            cell?.textLabel?.text = "hehe"
        }
        else {
            cell?.textLabel?.text = "hehe"
        }
        return cell!
    }
}

extension PersonSideBar: UIGestureRecognizerDelegate{
    
}
