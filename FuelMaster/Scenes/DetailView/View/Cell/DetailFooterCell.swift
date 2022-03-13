//
//  DetailFooterCell.swift
//  FuelMaster
//
//  Created by Aura Silos on 9/11/21.
//

import UIKit

protocol detailFooterDelegate: AnyObject {
    func tapFav()
    func tapShare()
}

class DetailFooterCell: UITableViewCell {

    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var disclaimerLabel: UILabel!
    
    weak var delegate: detailFooterDelegate?
    var isAlreadyFav = false 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if isAlreadyFav {
            
            favButton.setTitle("Quitar de favoritos", for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func favAction(_ sender: Any) {
        if isAlreadyFav {
            
            favButton.setTitle("Añadir a favoritos", for: .normal)
        } else {
            
            favButton.setTitle("Quitar de favoritos", for: .normal)
        }
        delegate?.tapFav()
    }
    
    @IBAction func shareAction(_ sender: Any) {
        delegate?.tapShare()
    }
}
