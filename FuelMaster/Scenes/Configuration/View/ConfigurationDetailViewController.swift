//
//  ConfigurationDetailViewController.swift
//  FuelMaster
//
//  Created by Aura Silos on 28/12/21.
//

import Foundation
import UIKit
import CoreLocation

class ConfigurationDetailViewController: UITableViewController {
    
    var typesList: [GasPreference] = []
    var currentSelection = GasType.gasoline
    
    override func viewDidLoad() {
        let nib = UINib(nibName: "ConfigurationCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ConfigurationCell")
        let nibTank = UINib(nibName: "DepositCell", bundle: nil)
        self.tableView.register(nibTank, forCellReuseIdentifier: "DepositCell")

        if let gasType = UserDefaults.standard.value(forKey: "gasType") as? String {
            
            self.currentSelection = GasType(rawValue: gasType)!
        }
        
        GasType.allCases.forEach { type in
            
            self.typesList.append(GasPreference(type: type, selected: self.currentSelection == type))
        }
        
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            return 1
        } else {
         
            return typesList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            
            return "Tamaño del depósito"
        } else {
            
            return "Combustible preferido"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            
            return 70
        } else {
            
            return tableView.rowHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DepositCell", for: indexPath) as? DepositCell
            return cell!
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigurationCell", for: indexPath) as? ConfigurationCell
            
            cell?.typeLabel.text = typesList[indexPath.row].type.rawValue
            cell?.chevronImage.image = typesList[indexPath.row].selected ? UIImage(systemName: "checkmark") : UIImage(systemName: "")
            
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var copyList: [GasPreference] = []
        
        for var i in self.typesList {
            
            i.selected = false
            copyList.append(i)
        }
        
        self.typesList = copyList
        
        self.typesList[indexPath.row].selected = true
        
        UserDefaults.standard.set(self.typesList[indexPath.row].type.rawValue, forKey: "gasType")
        let manager = APIManager()
        if let locationmanager = Constants.displacedLication {
            
            manager.userLocation = locationmanager
            manager.changeMainList()
        } else {
            
            if let locationManager = Constants.userLocation,
               let location = locationManager.location {
                
                manager.userLocation = location
                manager.changeMainList()
            } else {
                
                manager.userLocation = CLLocation(latitude: 40.4165000, longitude: -3.7025600)
                manager.changeMainList()
            }
        }
        self.tableView.reloadData()
    }
}
