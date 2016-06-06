//
//  HistoryDataModel.swift
//  EducationSystem
//
//  Created by Serx on 16/5/23.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import Foundation

class HistoryDataModel {
    
    /**
     toWriteArray: befroe change the record, you should put data to
     
     toReadArray:  the data read from .plist,
     get data via this property
     */
    var toWriteArray: NSMutableArray!
    var toReadArray: [String] = []
    
    /**
     write the data to the .plist
     */
    func dataWrite(){
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("userNameData.plist")
        //writing to GameData.plist
        toWriteArray.writeToFile(path, atomically: false)
        let resultArray = NSArray(contentsOfFile: path)
        print("Saved userNameData.plist file is --> \(resultArray?.description)")
    }
    
    func dataRead(clean: Bool){
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("userNameData.plist")
        let fileManager = NSFileManager()
        if !fileManager.fileExistsAtPath(path){
            if let bundlePath = NSBundle.mainBundle().pathForResource("userNameData", ofType: "plist"){
                let resultArray = NSArray(contentsOfFile: path)
                print("Saved userNameData.plist file is --> \(resultArray?.description)")
                do{
                    _ = try fileManager.copyItemAtPath(bundlePath, toPath: path)
                }catch{
                }
            }else{
                print("userName.plist not found. Please, make sure it is part of the bundle.")
            }
        }else{
            print("userName.plist already exits at path.")
            //TODO: clean all record
            // use this to delete file from documents directory
            if clean {
                do {
                    try fileManager.removeItemAtPath(path)
                    NSLog("clean success")
                }
                catch let error as NSError {
                    NSLog("fine error while clean login data")
                    print(error.localizedDescription)
                }
            }
        }
        if let resultArray = NSArray(contentsOfFile: path) as? [String]{
            print("Loaded userNameData.plist file is --> \(resultArray.description)")
            self.toReadArray = resultArray
        }
    }
    
    //MARK: string match method
    func sl_matchlist(stringArray: [String], strCmp: String) -> [String]{
        
        var result = [String]()
        result = stringArray.filter({ ( username: String) -> Bool in
            let nameMatch = username.rangeOfString(strCmp, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return nameMatch != nil
        })
        var limArray = [Int]()
        for str in result {
            let getInt = Int(str)
            limArray.append(getInt!)
        }
        result = []
        let resultSort = limArray.sort()
        for item in resultSort {
            let str = String(item)
            result.append(str)
        }
//        print(result)
        
//        var resultArray: [String] = []
//        for matched in stringArray{
//            if matched.characters.count >= strCmp.characters.count{
//                if userMatch(strCmp, str2: matched){
//                    resultArray.append(matched)
//                }
//            }
//        }
        return result
    }
    
    /**
     match two string start from the position of str1's header to the posistion of str1's end
     return true or false, indicate two string is equel and not equel
     */
    func userMatch(str1: String , str2: String) -> Bool{
        let lim = str1.endIndex
        let limStr2 = str2.substringToIndex(lim)
        if str1 == limStr2{
            return true
        }else{
            return false
        }
    }
}

