//
//  segView.swift
//  EducationSystem
//
//  Created by Serx on 16/5/30.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit

class segView: UIViewController {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var searchBar2: UISearchBar!
    
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var imageView: UIImageView!
    

    
    override func viewDidLayoutSubviews() {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let rect = CGRectMake(0, -44, MasterViewController.getUIScreenSize(true), 44)
        self.searchBar2 = UISearchBar.init(frame: rect)
        self.searchBar2.alpha = 0
        self.searchBar2.placeholder = "输入关键字"
        
        self.view.addSubview(self.searchBar2)
        
    }
    
    @IBAction func action(sender: AnyObject) {
        UIView.animateWithDuration(0.5) {
//            self.tableView.contentInset.top = 44
//            self.searchBar2.alpha = 1.0
//            self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
            self.tableView.frame = CGRectMake(0, 44, MasterViewController.getUIScreenSize(true), MasterViewController.getUIScreenSize(false))
            self.searchBar2.frame = CGRectMake(0, 0, MasterViewController.getUIScreenSize(true), 44)
            self.searchBar2.alpha = 1.0

        }
    }
    
    @IBAction func hide(sender: AnyObject) {
        
        UIView.animateWithDuration(0.4, animations: {
            self.tableView.frame = CGRectMake(0, 0, MasterViewController.getUIScreenSize(true), MasterViewController.getUIScreenSize(false))
            self.searchBar2.frame = CGRectMake(0, -44, MasterViewController.getUIScreenSize(true), 44)
            self.searchBar2.alpha = 0
            }) { (complete) in
                self.searchBar2.endEditing(complete)
                self.searchBar2.text = ""
        }
    }
}



extension segView: UITableViewDelegate {
    
}

extension segView: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier: String = "myCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        cell.textLabel?.text = String(indexPath.row)
        cell.backgroundColor = UIColor.blueColor()
        return cell
    }
}
