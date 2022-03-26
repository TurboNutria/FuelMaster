//
//  DepositCell.swift
//  FuelMaster
//
//  Created by 600c-87481 on 26/3/22.
//

import UIKit

class DepositCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    var currentTank: Int = 50
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        if let tank = UserDefaults.standard.value(forKey: "liters") as? Int {
            
            self.currentTank = tank
            textField.text = String(tank)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
