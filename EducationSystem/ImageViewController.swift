//
//  ImageViewController.swift
//  EducationSystem
//
//  Created by Serx on 16/5/29.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit
import AFNetworking
import Qiniu
import HappyDNS

class ImageViewController: UIViewController {

    let tokenURL: String = "https://usth.eycia.me/head/getToken"
    var token: String!
    
    @IBOutlet weak var headImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getToken()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getToken(){
        loginSession.GET(tokenURL, parameters: nil, success: { (dataTask, respons) in
            let err = respons["err"] as! Int
            if err == 0 {
                self.token = respons["data"] as! String
            }
            }) { (dataTask, error) in
                print(error)
        }
    }
    
    func uploadWithName(fileName: String, content: UIImage) {
        let myData = UIImagePNGRepresentation(content)
        // 如果覆盖已有的文件，则指定文件名。否则如果同名文件已存在，会上传失败
        let uploader: QNUploadManager = QNUploadManager()
        uploader.putData(myData, key: "2013025014", token: self.token, complete: { (info: QNResponseInfo!, key: String!, resp: [NSObject : AnyObject]!) -> Void in
            if info.ok {
                NSLog("Success")
                print(info)
                print(resp)
            } else {
                NSLog("Error: " + info.error.description)
            }
            }, option: nil)
    }
    
    @IBAction func chooseImage(sender: AnyObject) {
        
    }
    @IBAction func upLoadImage(sender: AnyObject) {
        let myImage = UIImage(named: "uploadTest.png")!
        self.uploadWithName("test.png", content: myImage)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
