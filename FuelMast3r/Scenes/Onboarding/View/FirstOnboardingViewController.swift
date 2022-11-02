//
//  FirstOnboardingViewController.swift
//  FuelMaster
//
//  Created by 600c-87481 on 16/3/22.
//

import Foundation
import UIKit

class FirstOnboardingViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    
    var delegate: onboardingProtocol?
    
    override func viewDidLoad() {
        self.nextButton.layer.cornerRadius = self.nextButton.frame.height / 2
    }
    @IBAction func nextAction(_ sender: Any) {
        performSegue(withIdentifier: "secondSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        let vc = segue.destination as! GasTypeViewController
        vc.delegate = self.delegate
    }
}
