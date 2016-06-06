//
//  SituationWebViewController.swift
//  EducationSystem
//
//  Created by Serx on 16/6/6.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class SituationWebViewController: UIViewController {

    var webView = WKWebView()
    var url: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.lt_setBackgroundColor(themeColor)
        self.view.addSubview(webView)
        self.webView.frame = self.view.bounds
        // Do any additional setup after loading the view.
        
        let url = NSURL(string:self.url)!
        let req = NSURLRequest(URL:url)
        self.webView.loadRequest(req)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
