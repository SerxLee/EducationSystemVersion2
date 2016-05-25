//
//  MasterViewController.swift
//  EducationSystem
//
//  Created by Serx on 16/5/25.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    var masterPageViewController: MasterPageViewController? {
        didSet {
            masterPageViewController?.masterDelegate = self
        }
    }
    lazy var logicManager: MasterLogicManager = {return MasterLogicManager()}()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MasterViewController: MasterPageViewControllerDelegate {
    
    func masterPageViewController(masterPageViewController: MasterPageViewController, didUpdatePageIndex index: Int) {
        print(index)
    }
    
    func masterPageViewController(masterPageViewController: MasterPageViewController, didUpdatePageCount count: Int){
        print(count)
    }
}
