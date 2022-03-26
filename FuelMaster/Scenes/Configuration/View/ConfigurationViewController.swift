//
//  ConfigurationViewController.swift
//  FuelMaster
//
//  Created by Aura Silos on 28/12/21.
//

import Foundation
import UIKit

class ConfigurationViewController: UITableViewController {
    
    override func viewDidLoad() {
        let nib = UINib(nibName: "ConfigurationCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ConfigurationCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            return 1
        } else {
            
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            
            return ""
        } else {
            
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigurationCell", for: indexPath) as? ConfigurationCell
        
        if indexPath.section == 0 {
            
            cell?.typeLabel.text = "Mi vehículo"

        } else {
            
            cell?.typeLabel.text = "Acerca de"
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            self.performSegue(withIdentifier: "detailSegue", sender: nil)
        } else if indexPath.section == 1 {
            
            self.performSegue(withIdentifier: "aboutSegue", sender: nil)
        } else {
            
            self.performSegue(withIdentifier: "detailSegue", sender: nil)
        }
    }
    
    @IBAction func closeAction(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
