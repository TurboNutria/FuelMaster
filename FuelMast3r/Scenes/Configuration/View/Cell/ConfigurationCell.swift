//
//  ConfigurationCell.swift
//  FuelMaster
//
//  Created by Aura Silos on 27/12/21.
//

import UIKit

class ConfigurationCell: UITableViewCell {

    @IBOutlet weak var chevronImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
