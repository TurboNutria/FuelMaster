//
//  LoadingViewController.swift
//  FuelMaster
//
//  Created by Aura Silos on 21/12/21.
//

import Foundation
import UIKit

class LoadingViewController: UIViewController {
    
    override func viewDidLoad() {
       
        APIManager().getDataFromMinisty { output in
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("foundData"), object: nil)
                
                
            }
        }
    }
}

