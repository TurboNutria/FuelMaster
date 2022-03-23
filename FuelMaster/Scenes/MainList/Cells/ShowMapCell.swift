//
//  ShowMapCell.swift
//  FuelMaster
//
//  Created by Aura Silos on 7/11/21.
//

import UIKit

protocol ShowMapDelegate: AnyObject {
    func showMap()
}

class ShowMapCell: UITableViewCell {

    @IBOutlet weak var showMapButton: UIButton!
    
    weak var delegate: ShowMapDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showMapButton.layer.cornerRadius = showMapButton.frame.height / 2
        self.showMapButton.layer.borderColor = UIColor(named: "borderColor")!.cgColor
        self.showMapButton.layer.borderWidth = 1
        self.selectedBackgroundView?.backgroundColor = .clear
        selectionStyle = .none
    }

    @IBAction func showMapAction(_ sender: Any) {
        
        if let d = delegate {
            
            d.showMap()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
