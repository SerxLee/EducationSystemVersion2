//
//  UINavigationBar+LTNavigationBar.swift
//  EducationSystem
//
//  Created by Serx on 16/5/25.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import Foundation
import UIKit


extension UINavigationBar {
    private struct AssociatedKeys {
        static var overlayKey = "overlayKey"
        static var emptyImageKey = "emptyImageKey"
    }
    
    var overlay: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.overlayKey) as? UIView
        }
        set {
//            objc_setAssociatedObject(self, &AssociatedKeys.overlayKey, newValue, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            objc_setAssociatedObject(self, &AssociatedKeys.overlayKey, newValue,  objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var emptyImage: UIImage? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.emptyImageKey) as? UIImage
        }
        set {
//            objc_setAssociatedObject(self, &AssociatedKeys.emptyImageKey, newValue, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            objc_setAssociatedObject(self, &AssociatedKeys.emptyImageKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func lt_setBackgroundColor(backgroundColor: UIColor?) {
        if ((self.overlay == nil)) {
            self.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            self.overlay = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.mainScreen().bounds.size.width, height: self.bounds.size.height + 20))
            self.overlay!.userInteractionEnabled = false
            self.overlay!.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            
            self.insertSubview(self.overlay!, atIndex: 0)
        }
        self.overlay!.backgroundColor = backgroundColor
    }
    
    func lt_setTranslationY(translationY: CGFloat) {
        self.transform = CGAffineTransformMakeTranslation(0, translationY)
    }
    
    func lt_setContentAlpha(alpha: CGFloat) {
        if self.overlay == nil {
            self.lt_setBackgroundColor(self.barTintColor)
        }
        self.setAlpha(alpha, forSubviewsOfView: self)
        if alpha == 1 {
            if self.emptyImage == nil {
                self.emptyImage = UIImage()
            }
            self.backIndicatorImage = self.emptyImage
        }
    }
    
    func setAlpha(aplha: CGFloat, forSubviewsOfView view: UIView) {
        for subview in view.subviews {
            if let view = subview as? UIView {
                if view == self.overlay {
                    continue
                }
                view.alpha = alpha
                self.setAlpha(alpha, forSubviewsOfView: view)
            }
        }
    }
    
    func lt_reset() {
        self.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        self.shadowImage = nil
        self.overlay?.removeFromSuperview()
        self.overlay = nil
    }
}
