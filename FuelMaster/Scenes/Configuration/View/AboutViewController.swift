//
//  AboutViewController.swift
//  FuelMaster
//
//  Created by 600c-87481 on 17/3/22.
//

import Foundation
import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        versionLabel.text = "Versión \(appVersion!)"
        
    }
}
