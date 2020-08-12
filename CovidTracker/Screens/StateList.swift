//
//  StateList.swift
//  CovidTracker
//
//  Created by IndianMoney.com on 09/08/20.
//  Copyright © 2020 IndianMoney.com. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class StateList: loaderView, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate {
    
    let ns = UserDefaults.standard
        
    var getAllDataInfo = NSMutableArray()

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var tableview: UITableView!
    
    var filteredArray = NSMutableArray()
    
    var shouldShowSearchResults = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.activityIndicatorBegin(loadColour: UIActivityIndicatorView.Style.medium)
       
        self.getAllDataInfo = FMDBDatabaseModel.getInstance().covidGetAllData()
        
        self.activityIndicatorEnds()
        self.tableview.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        self.bgView.layer.cornerRadius = 20
        self.bgView.clipsToBounds = true
        
        self.searchField.delegate = self
        self.searchField.text = "Search Your State"
        self.searchField.textColor = .lightGray
        self.searchField.resignFirstResponder()
        
        self.searchBtn.alpha = 1
        self.cancelBtn.alpha = 0

    }
    
    @IBAction func searchBtnPressed(_ sender: UIButton) {
        
        if (searchField.text?.isEmpty == false &&  searchField.text != "Search Your State"){
            self.searchBtn.alpha = 0
            self.cancelBtn.alpha = 1
                   
        }
        self.searchField.resignFirstResponder()
    }
    
    
    @IBAction func cancelBtnOressed(_ sender: UIButton) {
        
     if (searchField.text?.isEmpty != true &&  searchField.text != "Search Your State"){
                
            self.searchBtn.alpha = 1
            self.cancelBtn.alpha = 0
            self.searchField.text = "Search Your State"
            self.searchField.textColor = .lightGray
        }
        tableview.reloadData()
        self.searchField.resignFirstResponder()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(self.searchField.text == "Search Your State"){
            self.searchField.text = ""
            self.searchField.textColor = .black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(self.searchField.text?.isEmpty == true){
            self.searchField.text = "Search Your State"
            self.searchField.textColor = .lightGray
        }
    }
    
  
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if (searchField.text?.isEmpty == false &&  searchField.text != "Search Your State"){
            self.cancelBtn.alpha = 1
            self.searchBtn.alpha = 0
              
            let searchString = "%\(String(describing: self.searchField.text!))%"
           
            // Filter the data array and get only those countries that match the search text.
            self.filteredArray = FMDBDatabaseModel.getInstance().searchFromList(searchState: searchString)
        }
        else{
            self.cancelBtn.alpha = 0
            self.searchBtn.alpha = 1
        }
        self.tableview.reloadData()
    }
    
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n"  // Recognizes enter key in keyboard
        {
            searchField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchField.text?.isEmpty == false &&  searchField.text != "Search Your State"){
            return filteredArray.count
        }
        else{
            return self.getAllDataInfo.count
        }
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StateListCell", for: indexPath) as! StateListCell
        
        var l = covidDetails()
        
        if(getAllDataInfo.count != 0 || filteredArray.count != 0){
            
            if (searchField.text?.isEmpty == false &&  searchField.text != "Search Your State") {
                l = filteredArray.object(at: indexPath.row) as! covidDetails
            }else{
                l = getAllDataInfo.object(at: indexPath.row) as! covidDetails
            }
             cell.stateName.text = "\(l.state)"
            cell.activeText.text = "\(l.active)"
            cell.recoveredText.text = "\(l.recovered)"
            cell.deltaRecoveredText.text = " \(l.deltarecovered)"
            cell.deathText.text = "\(l.deaths)"
            cell.deltaDeathText.text = " \(l.deltadeaths)"
            cell.confirmedText.text = "\(l.confirmed)"
            cell.deltaConfirmedText.text = " \(l.deltaconfirmed)"
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var l = covidDetails()
        if (searchField.text?.isEmpty == false &&  searchField.text != "Search Your State") {
            l = filteredArray.object(at: indexPath.row) as! covidDetails
        }else{
            l = getAllDataInfo.object(at: indexPath.row) as! covidDetails
        }
        let array: [Any] = [l.active,l.confirmed,l.deaths,l.deltaconfirmed,l.deltadeaths,l.deltarecovered,l.recovered,l.lastupdatedtime,l.state,l.statecode,l.statenotes]

        ns.set(array, forKey: "stateDetails")
        
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StateDetailsScreen")
               self.navigationController?.pushViewController(VC, animated: true)
    }
}


class StateListCell: UITableViewCell{
    
    @IBOutlet weak var stateName: UILabel!
    
    @IBOutlet weak var activeText: UILabel!
    
    @IBOutlet weak var recoveredText: UILabel!
    
    @IBOutlet weak var deltaRecoveredText: UILabel!
    
    @IBOutlet weak var deathText: UILabel!
    
    @IBOutlet weak var deltaDeathText: UILabel!
    
    @IBOutlet weak var confirmedText: UILabel!
    
    @IBOutlet weak var deltaConfirmedText: UILabel!
}


