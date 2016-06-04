//
//  currentDevice.swift
//  Northern Beauty
//
//  Created by Serx on 16/4/23.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import Foundation
import UIKit

enum DeviceType {
    case iphone6plus
    case iphone6
    case iphone5
    case iphone4
    case ipad
}


class currentDevice {
    
    let iOSDeviceScreenSize: CGSize = UIScreen.mainScreen().bounds.size
    
    func getInfo() -> DeviceType{
        
        /*
         iPhone 6 plus/ 6s plus: 736 x 414
         iPhone 6/ 6s          : 667 x 375
         iPhone 5/ 5s/ se/ 5c  : 568 x 320
         iPhone 4s             : 480 x 320
         
         iPad Air              : 1024 x 768
         iPad3                 : 1024 x 768
         iPad2                 : 1024 x 768
         iPad mini2            : 1024 x 768
         iPad mini             : 1024 x 768
         
         scroll view 
         6 <=  187.5 = (width / 2)              before
           >=  562.5 = (width / 2) + width      next
        */
        
        var deviceType: DeviceType = .iphone5
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone{
            
            if iOSDeviceScreenSize.height > iOSDeviceScreenSize.width{
                
                if iOSDeviceScreenSize.height == 568{
                    NSLog("iPhone 5/5s/5c/se/ipod touch5")
                    deviceType = .iphone5
                }else if iOSDeviceScreenSize.height == 667{
                    NSLog("iPhone 6/6s")
                    deviceType = .iphone6
                }else if iOSDeviceScreenSize.height == 736{
                    NSLog("iPhone 6 plus/ 6s plus")
                    deviceType = .iphone6plus
                }else{
                    NSLog("iPhone 4s and other device")
                    deviceType = .iphone4
                }
            }
            if iOSDeviceScreenSize.width > iOSDeviceScreenSize.height{
                
                if iOSDeviceScreenSize.width == 568{
                    NSLog("iPhone 5/5s/5c/se/ipod touch5")
                }else if iOSDeviceScreenSize.width == 667{
                    NSLog("iPhone 6/6s")
                }else if iOSDeviceScreenSize.width == 736{
                    NSLog("iPhone 6 plus/ 6s plus")
                }else{
                    NSLog("iPhone 4s and other device")
                }
            }
        }else if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad{
            deviceType = .ipad
        }
        return deviceType
    }
}