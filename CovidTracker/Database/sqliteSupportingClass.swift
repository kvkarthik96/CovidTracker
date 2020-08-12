//
//  sqliteSupportingClass.swift
//  CovidTracker
//
//  Created by C S Sudheer on 10/08/20.
//  Copyright © 2020 IndianMoney.com. All rights reserved.

import Foundation
import UIKit

class Util:NSObject{
    
    class func getPath(fileName:String) -> String{
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let  fileURL = documentsURL.appendingPathComponent(fileName)
        return fileURL.path
    }
    
    class func copyFile(fileName: NSString){
        let dbPath: String = getPath(fileName: fileName as String)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath){
            let documentsURL = Bundle.main.resourceURL
            let fromPath = documentsURL!.appendingPathComponent(fileName as String)
            do{
                try fileManager.copyItem(atPath: fromPath.path, toPath: dbPath)
            }catch let error1 as NSError{
                debugPrint(error1)
            }
        }else{
            
        }
    }
}
