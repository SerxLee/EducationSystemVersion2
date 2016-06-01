//
//  Double+SaveTwo.swift
//  EducationSystem
//
//  Created by Serx on 16/6/1.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import Foundation

/** SaveTwo Extends Double

*/
extension Double {
    
    var double1: Double {
        get {
            let lim = Int(self * 10 + 0.5)
            let lim2 = Double(lim)
            return lim2 / 10
        }
        set {
            
        }
    }
    var double2: Double {
        get {
            let lim = Int(self * 100 + 0.5)
            let lim2 = Double(lim)
            return lim2 / 100
        }
        set {
            
        }
    }
}
