//
//  DashBoard.swift
//  CovidTracker
//
//  Created by IndianMoney.com on 09/08/20.
//  Copyright © 2020 IndianMoney.com. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DashBoard: loaderView {
    
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var viewAllButton: UIButton!
    
    @IBOutlet weak var activeCases: UILabel!
    
    @IBOutlet weak var recovered: UILabel!
    
    @IBOutlet weak var recovered2: UILabel!
    
    @IBOutlet weak var deceased: UILabel!
    
    @IBOutlet weak var deceased2: UILabel!
    
    @IBOutlet weak var confirmed: UILabel!
    
    @IBOutlet weak var confirmed2: UILabel!
    
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var indiaActiveCases: UILabel!
    
    @IBOutlet weak var indiaRecovered: UILabel!
    
    @IBOutlet weak var indiaRecovered2: UILabel!
    
    @IBOutlet weak var indiaDeceased: UILabel!
    
    @IBOutlet weak var indiaDeceased2: UILabel!
    
    @IBOutlet weak var indiaConfirmed: UILabel!
    
    @IBOutlet weak var indiaConfirmed2: UILabel!
   
    // For local database
    var GetAlldataInfo = NSMutableArray()
    
    override func viewDidAppear(_ animated: Bool) {
        FMDBDatabaseModel.getInstance().DBCreation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(currentReachabilityStatus == .notReachable)
        {
            self.noInternetAlert()
        }else
        {
            
            self.activityIndicatorBegin(loadColour: UIActivityIndicatorView.Style.gray)
            // Deleting local db
            GetAlldataInfo = FMDBDatabaseModel.getInstance().deleteAllCovidList()
            
            // get covid details service call
            self.serviceCall()
        }
    }
    
    
    @IBAction func viewAllStateList(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "StateList") as! StateList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //background view corner radius
        self.bgView.layer.cornerRadius = 10
        self.bgView.clipsToBounds = true
        
        self.viewAllButton.layer.cornerRadius = 20
        self.viewAllButton.clipsToBounds = true
    }
}


/*  Service Call */
extension DashBoard {
    func serviceCall(){
          
          AF.request("https://api.covid19india.org/data.json", method: .get,  encoding: JSONEncoding.default)
                  .responseJSON { response in
                    
                     self.activityIndicatorEnds()
                    
                      switch response.result {
                      case .success(let value):
                          let json = JSON(value)
                              for info in json["statewise"].arrayValue
                              {
                                  // inserting into local database
                                  let FMDBInfo:covidDetails = covidDetails()
                             
                                     FMDBInfo.active = info["active"].stringValue
                                     FMDBInfo.confirmed = info["confirmed"].stringValue
                                     FMDBInfo.deaths = info["deaths"].stringValue
                                     FMDBInfo.deltaconfirmed = info["deltaconfirmed"].stringValue
                                     FMDBInfo.deltadeaths = info["deltadeaths"].stringValue
                                     FMDBInfo.deltarecovered = info["deltarecovered"].stringValue
                                     FMDBInfo.migratedother = info["migratedother"].stringValue
                                     FMDBInfo.recovered = info["recovered"].stringValue
                                     FMDBInfo.lastupdatedtime = info["lastupdatedtime"].stringValue
                                     FMDBInfo.state = info["state"].stringValue
                                     FMDBInfo.statecode = info["statecode"].stringValue
                                     FMDBInfo.statenotes = info["statenotes"].stringValue
                                
                                if(info["statecode"].stringValue != "TT"){
                                    let isInserted = FMDBDatabaseModel.getInstance().insertCovidDetails(FMDBInfo)
                                    if isInserted{
                                      //  print("Inserted into db")
                                    }else{
                                      //  print("Error while inserting data")
                                    }
                                }
                                
                                    
                                 
                                    // to Display Karnataka covid details
                                    if(info["statecode"].stringValue == "KA"){
                                        self.activeCases.text = info["active"].stringValue
                                        self.recovered.text = info["recovered"].stringValue
                                        self.recovered2.text = "   \(info["deltarecovered"].stringValue)"
                                        self.deceased.text = info["deaths"].stringValue
                                        self.deceased2.text = "   \(info["deltadeaths"].stringValue)"
                                        self.confirmed.text = info["confirmed"].stringValue
                                        self.confirmed2.text = "   \(info["deltaconfirmed"].stringValue)"
                                    }
                                
                                    if(info["statecode"].stringValue == "TT"){
                                        self.lastUpdateLabel.text = "Last Updated On: \(info["lastupdatedtime"].stringValue)"
                                        self.indiaActiveCases.text = info["active"].stringValue
                                        self.indiaRecovered.text = info["recovered"].stringValue
                                        self.indiaRecovered2.text = "   \(info["deltarecovered"].stringValue)"
                                        self.indiaDeceased.text = info["deaths"].stringValue
                                        self.indiaRecovered2.text = "   \(info["deltadeaths"].stringValue)"
                                        self.indiaConfirmed.text = info["confirmed"].stringValue
                                        self.indiaConfirmed2.text = "   \(info["deltaconfirmed"].stringValue)"
                                    }
                               
                              }
                      case .failure(let error):
                          print(error)
                      }
                }
        }
}

