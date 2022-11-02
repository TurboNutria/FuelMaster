//
//  DiscountOwnerCell.swift
//  FuelMaster
//
//  Created by 600c-87481 on 17/4/22.
//

import UIKit

class DiscountOwnerCell: UITableViewCell {
    
    @IBOutlet weak var contentViewq: UIView!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentViewq.layer.cornerRadius = self.contentViewq.frame.height / 2
        self.ownerImage.layer.cornerRadius = self.ownerImage.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
