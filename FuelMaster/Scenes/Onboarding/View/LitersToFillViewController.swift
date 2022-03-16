//
//  LitersToFillViewController.swift
//  FuelMaster
//
//  Created by 600c-87481 on 16/3/22.
//

import Foundation
import UIKit

protocol onboardingProtocol: AnyObject {
    func finishedOnboarding()
}

class LitersToFillViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var delegate: onboardingProtocol?
    
    override func viewDidLoad() {
        textField.delegate = self
        self.nextButton.layer.cornerRadius = self.nextButton.frame.height / 2
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOutside))
        self.view.addGestureRecognizer(tap)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.saveLiters()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.saveLiters()
        return true
    }
    
    @objc func tapOutside() {
        saveLiters()
    }
    
    func saveLiters() {
        self.textField.resignFirstResponder()
        if let text = self.textField.text,
        let textInt = Int(text) {
            
            UserDefaults.standard.set(textInt, forKey: "liters")
        } else {
            
            UserDefaults.standard.set(50, forKey: "liters")
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        self.delegate?.finishedOnboarding()
        if let _ = UserDefaults.standard.value(forKey: "liters") as? Int {
            
            self.dismiss(animated: true)
        } else {
            
            UserDefaults.standard.set(50, forKey: "liters")
            self.dismiss(animated: true)
        }
        
    }
}
