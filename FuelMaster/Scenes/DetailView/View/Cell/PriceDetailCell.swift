//
//  PriceDetailCell.swift
//  FuelMaster
//
//  Created by Aura Silos on 9/11/21.
//

import UIKit

class PriceDetailCell: UICollectionViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 20
        self.layer.borderColor = UIColor(named:"borderColor")!.cgColor
        self.layer.borderWidth = 2.0

    }

}
