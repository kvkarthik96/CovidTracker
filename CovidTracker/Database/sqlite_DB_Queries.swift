//
//  sqlite_DB_Queries.swift
//  CovidTracker
//
//  Created by C S Sudheer on 10/08/20.
//  Copyright © 2020 IndianMoney.com. All rights reserved.
//

 import Foundation
 import UIKit
 import SwiftyJSON

 let sharedInstance = FMDBDatabaseModel()
 var databasePathStr = NSString()

 class FMDBDatabaseModel:NSObject{
     
     var database:FMDatabase? = nil
     var GetAlldataInfo = NSMutableArray()
     
     class func getInstance() -> FMDBDatabaseModel
     {
         if(sharedInstance.database == nil){
             sharedInstance.database = FMDatabase(path:Util.getPath(fileName: "IMDatabase.sqlite"))
         }
         return sharedInstance
     }
    
    
    func DBCreation(){
     
        let filemngr = FileManager.default
        let filepaths = filemngr.urls(for: .documentDirectory, in: .userDomainMask)
     
        databasePathStr = filepaths[0].appendingPathComponent("IMDatabase.sqlite").path as NSString
        if (filemngr.fileExists(atPath: databasePathStr as String)) {
            let myDataBase = FMDatabase(path:databasePathStr as String)
       
            if(myDataBase.open()){
                let covid = "Create table if not exists coronaDetails (active TEXT, confirmed TEXT, deaths TEXT, deltaconfirmed TEXT, deltadeaths TEXT, deltarecovered TEXT, migratedother TEXT, recovered TEXT, lastupdatedtime TEXT, state TEXT, statecode TEXT, statenotes TEXT)"
           
                if !(myDataBase.executeStatements(covid)){
                    print("Table:\(myDataBase.lastErrorMessage())")
                }
            }
        }
    }
    
    // Insert Covid List
    func insertCovidDetails(_ Tbl_Info:covidDetails) -> Bool{
        sharedInstance.database!.open()
     
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO coronaDetails(active,confirmed,deaths,deltaconfirmed,deltadeaths,deltarecovered,migratedother,recovered,lastupdatedtime,state,statecode,statenotes) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)", withArgumentsIn: [Tbl_Info.active,Tbl_Info.confirmed,Tbl_Info.deaths,Tbl_Info.deltaconfirmed,Tbl_Info.deltadeaths,Tbl_Info.deltarecovered,Tbl_Info.migratedother,Tbl_Info.recovered,Tbl_Info.lastupdatedtime,Tbl_Info.state,Tbl_Info.statecode,Tbl_Info.statenotes])
     
        sharedInstance.database!.close()
     
        return (isInserted)
    }
 

    // get Covid List
    func covidGetAllData() -> NSMutableArray{
        sharedInstance.database!.open()
        let itemInfo:NSMutableArray = NSMutableArray ()
     
        let resultSet:FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM coronaDetails", withArgumentsIn: [])
     
        if(resultSet != nil){
            while resultSet.next(){
             
                let item:covidDetails = covidDetails()
             
                item.active = String(resultSet.string(forColumn: "active") ?? " ")
                item.confirmed = String(resultSet.string(forColumn: "confirmed") ?? " ")
                item.deaths = String(resultSet.string(forColumn: "deaths") ?? " ")
                item.deltaconfirmed = String(resultSet.string(forColumn: "deltaconfirmed") ?? " ")
                item.deltadeaths = String(resultSet.string(forColumn: "deltadeaths") ?? " ")
                item.deltarecovered = String(resultSet.string(forColumn: "deltarecovered") ?? " ")
                item.migratedother = String(resultSet.string(forColumn: "migratedother") ?? " ")
                item.recovered = String(resultSet.string(forColumn: "recovered") ?? " ")
                item.lastupdatedtime = String(resultSet.string(forColumn: "lastupdatedtime") ?? " ")
                item.state = String(resultSet.string(forColumn: "state") ?? " ")
                item.statecode = String(resultSet.string(forColumn: "statecode") ?? " ")
                item.statenotes = String(resultSet.string(forColumn: "statenotes") ?? " ")
                itemInfo.add(item)
            }
        }
        sharedInstance.database!.close()
        return itemInfo
    }
 
    // delete Covid List
    func deleteAllCovidList() -> NSMutableArray{
        sharedInstance.database!.open()
     
        let resultSet:FMResultSet! = sharedInstance.database!.executeQuery("DELETE FROM coronaDetails", withArgumentsIn: [])
     
        let itemInfo:NSMutableArray = NSMutableArray()
     
        if(resultSet != nil){
            while resultSet.next(){
                
                let item:covidDetails = covidDetails()
                         
                item.active = String(resultSet.string(forColumn: "active") ?? "")
                item.confirmed = String(resultSet.string(forColumn: "confirmed") ?? "")
                item.deaths = String(resultSet.string(forColumn: "deaths") ?? "")
                item.deltaconfirmed = String(resultSet.string(forColumn: "deltaconfirmed") ?? "")
                item.deltadeaths = String(resultSet.string(forColumn: "deltadeaths") ?? "")
                item.deltarecovered = String(resultSet.string(forColumn: "deltarecovered") ?? "")
                item.migratedother = String(resultSet.string(forColumn: "migratedother") ?? "")
                item.recovered = String(resultSet.string(forColumn: "recovered") ?? "")
                item.lastupdatedtime = String(resultSet.string(forColumn: "lastupdatedtime") ?? "")
                item.state = String(resultSet.string(forColumn: "state") ?? "")
                item.statecode = String(resultSet.string(forColumn: "statecode") ?? "")
                         item.statenotes = String(resultSet.string(forColumn: "statenotes") ?? "")
                       
                itemInfo.add(item)
            }
        }
        sharedInstance.database!.close()
        return itemInfo
    }
    
    // search
    func searchFromList(searchState:String) -> NSMutableArray{
        sharedInstance.database!.open()
        
        let resultSet:FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM coronaDetails WHERE state like ?", withArgumentsIn: [searchState])
        
        let itemInfo:NSMutableArray = NSMutableArray()
        
           if(resultSet != nil){
               while resultSet.next(){
                   
                   let item:covidDetails = covidDetails()
                            
                   item.active = String(resultSet.string(forColumn: "active") ?? "")
                   item.confirmed = String(resultSet.string(forColumn: "confirmed") ?? "")
                   item.deaths = String(resultSet.string(forColumn: "deaths") ?? "")
                   item.deltaconfirmed = String(resultSet.string(forColumn: "deltaconfirmed") ?? "")
                   item.deltadeaths = String(resultSet.string(forColumn: "deltadeaths") ?? "")
                   item.deltarecovered = String(resultSet.string(forColumn: "deltarecovered") ?? "")
                   item.migratedother = String(resultSet.string(forColumn: "migratedother") ?? "")
                   item.recovered = String(resultSet.string(forColumn: "recovered") ?? "")
                   item.lastupdatedtime = String(resultSet.string(forColumn: "lastupdatedtime") ?? "")
                   item.state = String(resultSet.string(forColumn: "state") ?? "")
                   item.statecode = String(resultSet.string(forColumn: "statecode") ?? "")
                            item.statenotes = String(resultSet.string(forColumn: "statenotes") ?? "")
                          
                   itemInfo.add(item)
               }
           }
           sharedInstance.database!.close()
           return itemInfo
       }
}
