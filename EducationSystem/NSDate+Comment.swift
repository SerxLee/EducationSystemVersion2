//
//  NSDate+Comment.swift
//  EducationSystem
//
//  Created by Serx on 16/5/27.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import Foundation

/** Comment Extends NSDate

*/
extension NSDate{
    class func handleDate(date: NSDate) -> NSDate?{
        let dateF = NSDateFormatter()
        dateF.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        let date2 = dateF.stringFromDate(date)
        let date = dateF.dateFromString(date2)
        return date
    }
    func fullDescription() -> String {
        let calendar = NSCalendar.currentCalendar()
        
        if calendar.isDateInToday(self) {
            let delta = Int(NSDate().timeIntervalSinceDate(self))
            if delta < 60 {
                return "刚刚"
            } else if delta < 60 * 60 {
                return "\(delta / 60)分钟前"
            }
            return "\(delta / 3600)小时前"
        }else {
            var dateformatString = ""
            if calendar.isDateInYesterday(self) {
                dateformatString = "昨天 HH:mm"
            } else {
                let result = calendar.components(.Year, fromDate: self, toDate: NSDate(), options: [])
                if result.year == 0 {
                    dateformatString = "MM-dd HH:mm"
                } else {
                    dateformatString = "yyyy-MM-dd HH:mm"
                }
            }
            let df = NSDateFormatter()
            df.dateFormat = dateformatString
            return df.stringFromDate(self)
        }
    }
}
