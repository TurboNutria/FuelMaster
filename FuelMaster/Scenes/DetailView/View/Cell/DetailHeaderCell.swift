//
//  DetailHeaderCell.swift
//  FuelMaster
//
//  Created by Aura Silos on 9/11/21.
//

import UIKit

protocol DetailHeaderProtocol: AnyObject {
    func tapNavigate()
}

class DetailHeaderCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var subAddressLabel: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    
    weak var delegate: DetailHeaderProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mapButton.setTitleColor(UIColor(named:"fontColor"), for: .normal)
        mapButton.layer.borderColor = UIColor(named:"borderColor")!.cgColor
        mapButton.layer.cornerRadius = mapButton.frame.height / 2
        self.ownerImage.layer.cornerRadius = self.ownerImage.layer.frame.height / 2
        mapButton.layer.borderWidth = 1.0
        self.selectedBackgroundView?.backgroundColor = .clear
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func rideAction(_ sender: Any) {
        if let d = delegate {
            
            d.tapNavigate()
        }
    }
}
