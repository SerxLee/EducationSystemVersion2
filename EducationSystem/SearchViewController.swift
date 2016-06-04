//
//  SearchViewController.swift
//  EducationSystem
//
//  Created by Serx on 16/5/30.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var leftBarItem: UIBarButtonItem!

    lazy var logicManager: SearchLogicManager = {return SearchLogicManager()}()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.fd_prefersNavigationBarHidden = true
        self.title = "搜索课程"
        self.initView()
    }
    
    func initView(){
        self.navigationController?.navigationBar.lt_setBackgroundColor(themeColor)
        
        let img = UIImage(named: "backImage")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.leftBarItem.image = img
        self.leftBarItem.style = .Plain
    }

    @IBAction func leftBarItemAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
//        self.navigationController?.navigationBar.lt_setBackgroundColor(themeColor.colorWithAlphaComponent(currentAlpha))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SearchViewController: UITableViewDelegate {
    
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier: String = "myCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        cell.textLabel?.text = "test"
        return cell
    }
}
