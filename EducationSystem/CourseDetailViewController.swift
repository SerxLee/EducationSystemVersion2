//
//  CourseDetailViewController.swift
//  EducationSystem
//
//  Created by Serx on 16/5/27.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit

var dict: NSDictionary!

class CourseDetailViewController: UIViewController {
    

    lazy var logicManager: CourseDetailLogicManager = {return CourseDetailLogicManager()}()
    
    @IBOutlet weak var rightBarItem: UIBarButtonItem!
    @IBOutlet weak var leftBarItem: UIBarButtonItem!
    
    var classViewModel: CourseDetailViewModel!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    func initView() {
        self.classViewModel = self.logicManager.classViewModel
        self.navigationController?.navigationBar.lt_setBackgroundColor(themeColor)
        let img = UIImage(named: "shareImage")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.rightBarItem.image = img
        self.rightBarItem.style = .Plain
        
        let img2 = UIImage(named: "backImage")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.leftBarItem.image = img2
        self.leftBarItem.style = .Plain
    }
    
    //turn back action
    @IBAction func leftBarItemAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func rightBarItemAction(sender: AnyObject) {
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "DetailToComment" {
            let next = segue.destinationViewController as! CommentViewController
//            let next = na.topViewController as! CommentViewController
            next.className = (dict!["id"] as? String)!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
