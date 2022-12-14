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
        self.selectedBackgroundView?.backgroundColor = .clear
        selectionStyle = .none
        super.awakeFromNib()
        if let date = UserDefaults.standard.value(forKey: "fecha") as? Date {
            
            let currentDate = date
            let dateFormatted = currentDate.formatted(date: .abbreviated, time: .shortened)
            self.disclaimerLabel.text = "Datos obtenidos el día \(dateFormatted)"
        } else {
            
            let currentDate = Date()
            let dateFormatted = currentDate.formatted(date: .long, time: .shortened)
            self.disclaimerLabel.text = "Datos obtenidos el día \(dateFormatted)"
        }
        if isAlreadyFav {
            
            favButton.setTitle("Quitar de favoritos", for: .normal)
        }
        
        favButton.layer.borderWidth = 1
        shareButton.layer.borderWidth = 1
        shareButton.layer.borderColor = UIColor(named: "borderColor")!.cgColor
        favButton.layer.borderColor = UIColor(named: "borderColor")!.cgColor
        shareButton.layer.cornerRadius = shareButton.frame.height / 2
        favButton.layer.cornerRadius = favButton.frame.height / 2
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
