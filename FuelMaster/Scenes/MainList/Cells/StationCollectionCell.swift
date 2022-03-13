//
//  StationCollectionCell.swift
//  FuelMaster
//
//  Created by Aura Silos on 7/11/21.
//

import UIKit

class StationCollectionCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var regularGasLabel: UILabel!
    @IBOutlet weak var regularGasPrice: UILabel!
    @IBOutlet weak var superGasPrice: UILabel!
    @IBOutlet weak var superGasLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 25
        self.ownerImage.layer.cornerRadius = self.ownerImage.layer.frame.height / 2
    }
}
