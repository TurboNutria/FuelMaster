//
//  GasTypeViewController.swift
//  FuelMaster
//
//  Created by 600c-87481 on 16/3/22.
//

import Foundation
import UIKit

class GasTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var typesList: [GasPreference] = []
    var currentSelection = GasType.gasoline
    var delegate: onboardingProtocol?
    
    override func viewDidLoad() {
        
        self.nextButton.layer.cornerRadius = self.nextButton.frame.height / 2
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "ConfigurationCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ConfigurationCell")
        
        if let gasType = UserDefaults.standard.value(forKey: "gasType") as? String {
            
            self.currentSelection = GasType(rawValue: gasType)!
        } else {
            
            UserDefaults.standard.set("Gasolina", forKey: "gasType")
            self.currentSelection = .gasoline
        }
        
        GasType.allCases.forEach { type in
            
            self.typesList.append(GasPreference(type: type, selected: self.currentSelection == type))
        }
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigurationCell", for: indexPath) as? ConfigurationCell
        
        cell?.typeLabel.text = typesList[indexPath.row].type.rawValue
        cell?.chevronImage.image = typesList[indexPath.row].selected ? UIImage(systemName: "checkmark") : UIImage(systemName: "")
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typesList.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var copyList: [GasPreference] = []
        
        for var i in self.typesList {
            
            i.selected = false
            copyList.append(i)
        }
        
        self.typesList = copyList
        
        self.typesList[indexPath.row].selected = true

        UserDefaults.standard.set(self.typesList[indexPath.row].type.rawValue, forKey: "gasType")
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! LitersToFillViewController
        vc.delegate = self.delegate
    }
    
    @IBAction func nextAction(_ sender: Any) {
        performSegue(withIdentifier: "finalSegue", sender: nil)
    }
}
