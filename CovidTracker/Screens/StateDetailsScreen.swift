//
//  StateDetailsScreen.swift
//  CovidTracker
//
//  Created by IndianMoney.com on 11/08/20.
//  Copyright © 2020 IndianMoney.com. All rights reserved.
//

import UIKit

class StateDetailsScreen: UIViewController {
    
    let ns = UserDefaults.standard
    
    @IBOutlet weak var lastUpdatedText: UILabel!
    
    @IBOutlet weak var stateName: UILabel!
    
    @IBOutlet weak var stateCode: UILabel!
    
    @IBOutlet weak var activetext: UILabel!
    
    @IBOutlet weak var recoveredText: UILabel!
    
    @IBOutlet weak var deltaRecoveredText: UILabel!
    
    
    @IBOutlet weak var deathText: UILabel!
    
    @IBOutlet weak var deltaDeathText: UILabel!
    
    @IBOutlet weak var confirmedText: UILabel!
    
    @IBOutlet weak var deltaConfirmedText: UILabel!
    
    @IBOutlet weak var stateNote: UITextView!
    
    @IBOutlet weak var bgView: UIView!
    
    
    @IBOutlet weak var appBarTitle: UILabel!
    
    var navigationTitle:String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if(ns.object(forKey: "stateDetails") != nil){
                   let stateWiseCovideDetails:[Any] = ns.object(forKey: "stateDetails") as! [Any]
            
            self.navigationTitle = "\(stateWiseCovideDetails[8])"
            self.appBarTitle.text = navigationTitle
            self.stateName.text = navigationTitle
            self.stateCode.text = "State Code: \(stateWiseCovideDetails[9])"
            self.activetext.text = "\(stateWiseCovideDetails[0])"
            self.recoveredText.text = "\(stateWiseCovideDetails[6])"
            self.deltaRecoveredText.text = " \(stateWiseCovideDetails[5])"
            self.deathText.text = "\(stateWiseCovideDetails[2])"
            self.deltaDeathText.text = " \(stateWiseCovideDetails[4])"
            self.confirmedText.text = "\(stateWiseCovideDetails[1])"
            self.deltaConfirmedText.text = " \(stateWiseCovideDetails[3])"
            self.stateNote.text = "\(stateWiseCovideDetails[10])"
            self.lastUpdatedText.text = "Last Updated On: \(stateWiseCovideDetails[7])"
               }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bgView.layer.cornerRadius = 10
        self.bgView.clipsToBounds = true
        
    }
}
