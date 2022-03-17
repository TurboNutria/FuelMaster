//
//  TankConfigurationViewController.swift
//  FuelMaster
//
//  Created by 600c-87481 on 16/3/22.
//

import Foundation
import UIKit

class TankConfigurationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    var currentTank: Int = 50
    
    override func viewDidLoad() {
        if let tank = UserDefaults.standard.value(forKey: "liters") as? Int {
            
            self.currentTank = tank
            textField.text = String(tank)
        }
        textField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOutside))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func tapOutside() {
        saveLiters()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveLiters()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveLiters()
    }
    
    func saveLiters() {
        self.textField.resignFirstResponder()
        if let text = self.textField.text,
        let textInt = Int(text) {
            
            self.currentTank = textInt
            UserDefaults.standard.set(textInt, forKey: "liters")
        } else {
            
            UserDefaults.standard.set(currentTank, forKey: "liters")
        }
    }

    
}
