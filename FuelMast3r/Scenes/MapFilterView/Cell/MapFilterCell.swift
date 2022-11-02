//
//  MapFilterCell.swift
//  FuelMaster
//
//  Created by 600c-87481 on 12/3/22.
//

import UIKit

class MapFilterCell: UITableViewCell {

    @IBOutlet weak var filterDescription: UILabel!
    @IBOutlet weak var filterSelected: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
