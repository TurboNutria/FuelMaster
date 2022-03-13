//
//  StationCell.swift
//  FuelMaster
//
//  Created by Aura Silos on 4/11/21.
//

import UIKit

class StationCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var regularGasLabel: UILabel!
    @IBOutlet weak var superGasLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 25
        self.ownerImage.layer.cornerRadius = self.ownerImage.layer.frame.height / 2
        self.selectedBackgroundView?.backgroundColor = .clear
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
