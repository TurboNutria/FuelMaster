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

        if let gasType = UserDefaults.standard.value(forKey: "gasType") as? String {
            
            self.currentSelection = GasType(rawValue: gasType)!
        }
        
        GasType.allCases.forEach { type in
            
            self.typesList.append(GasPreference(type: type, selected: self.currentSelection == type))
        }
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typesList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigurationCell", for: indexPath) as? ConfigurationCell
        
        cell?.typeLabel.text = typesList[indexPath.row].type.rawValue
        cell?.chevronImage.image = typesList[indexPath.row].selected ? UIImage(systemName: "checkmark") : UIImage(systemName: "")
        
        return cell!
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
        if let locationmanager = Constants.userLocation,
           let location = locationmanager.location {
            
            manager.userLocation = Constants.userLocation?.location
            manager.changeMainList()
        } else {
            
            manager.userLocation = CLLocation(latitude: 40.4165000, longitude: -3.7025600)
            manager.changeMainList()
        }
        self.tableView.reloadData()
    }
}
