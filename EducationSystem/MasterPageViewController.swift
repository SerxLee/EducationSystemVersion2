//
//  MasterPageViewController.swift
//  EducationSystem
//
//  Created by Serx on 16/5/25.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit
import Observable

var scrollViewPanGestureRecognzier: UIPanGestureRecognizer!
var barSlideLenght: CGFloat = 0

class MasterPageViewController: UIPageViewController {

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    weak var masterDelegate: MasterPageViewControllerDelegate?
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        // The view controllers will be shown in this order
        return [self.newColoredViewController("PassingTVController"),
                self.newColoredViewController("SemesterTVController"),
                self.newColoredViewController("FailTVController")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let initialViewController = orderedViewControllers.first {
            scrollToViewController(initialViewController)
        }
        
        masterDelegate?.masterPageViewController(self,
                                                     didUpdatePageCount: orderedViewControllers.count)
    
        for view in self.view.subviews {
            if view.isKindOfClass(UIScrollView.self) {
                let scrollView: UIScrollView = view as! UIScrollView
                
                scrollView.delegate = self
                scrollViewPanGestureRecognzier = UIPanGestureRecognizer()
                scrollViewPanGestureRecognzier.delegate = self
                scrollView.addGestureRecognizer(scrollViewPanGestureRecognzier)
            }
        }
    
    }

    
    /**
     Scrolls to the next view controller.
 
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self,
                                                        viewControllerAfterViewController: visibleViewController) {
            scrollToViewController(nextViewController)
        }
    }
    */
    
    /**
     Scrolls to the view controller at the given index. Automatically calculates
     the direction.
     
     - parameter newIndex: the new index to scroll to
     */
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = orderedViewControllers.indexOf(firstViewController) {
            let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .Forward : .Reverse
            let nextViewController = orderedViewControllers[newIndex]
            scrollToViewController(nextViewController, direction: direction)
        }
    }
    
    private func newColoredViewController(controllerIdentifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(controllerIdentifier)
    }
    
    /**
     Scrolls to the given 'viewController' page.
     
     - parameter viewController: the view controller to show.
     */
    private func scrollToViewController(viewController: UIViewController,
                                        direction: UIPageViewControllerNavigationDirection = .Forward) {
        setViewControllers([viewController],
                           direction: direction,
                           animated: true,
                           completion: { (finished) -> Void in
                            // Setting the view controller programmatically does not fire
                            // any delegate methods, so we have to manually notify the
                            // 'masterDelegate' of the new index.
                            self.notifymasterDelegateOfNewIndex()
        })
    }
    
    /**
     Notifies '_masterDelegate' that the current page index was updated.
     */
    private func notifymasterDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.indexOf(firstViewController) {
            masterDelegate?.masterPageViewController(self,
                                                         didUpdatePageIndex: index)
        }
    }
    
}

// MARK: UIPageViewControllerDataSource

extension MasterPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
//            return orderedViewControllers.first
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}



extension MasterPageViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let width = MasterViewController.getUIScreenSize(true)
        if scrollView.contentOffset.y == 0 {
            let x = scrollView.contentOffset.x
//            print(x)
            //go to the back controller
            if x <= width / 2.0 {
                observeScrollView <- -1
            }
            //go to next controller
            else if x >= width / 2.0 + width {
                observeScrollView <- 1
            }
            else {
                observeScrollView <- 2
            }
        }
    }
}

extension MasterPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                                               previousViewControllers: [UIViewController],
                                               transitionCompleted completed: Bool) {
        //MARK: should change
        notifymasterDelegateOfNewIndex()
    }
}

extension MasterPageViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == scrollViewPanGestureRecognzier {
            
            let restrictValue:CGFloat = MasterViewController.getUIScreenSize(true) / 10
            // 标识不可滑动区域
//            let recognizerView: UIView = UIView(frame: CGRectMake(0, 0, 100, self.view.frame.height))
//            recognizerView.backgroundColor = UIColor.darkGrayColor()
//            self.view.addSubview(recognizerView)
            
            // 标识
//            let lb: UILabel = UILabel(frame: CGRectMake(90,180, 200, 50))
//            lb.text = "不可以滚动的区域"
//            lb.textColor = UIColor.whiteColor()
//            recognizerView.addSubview(lb)
            
            let locationInView: CGPoint = gestureRecognizer.locationInView(self.view)
            
            if  locationInView.x > restrictValue {
                return false
            } else {
                return true
            }
        }
        return false
    }
}

protocol MasterPageViewControllerDelegate: class {
    
    /**
     Called when the number of pages is updated.
     
     - parameter count: the total number of pages.
     */
    func masterPageViewController(masterPageViewController: MasterPageViewController,
                                    didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter index: the index of the currently visible page.
     */
    func masterPageViewController(masterPageViewController: MasterPageViewController,
                                    didUpdatePageIndex index: Int)
    
    
    
//    func masterPageViewController(masterPageViewController: MasterPageViewController,
//                                  didUpdatapageSlideLenght lenght: CGFloat)
    
}