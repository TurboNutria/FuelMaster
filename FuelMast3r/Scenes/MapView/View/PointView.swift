//
//  PointView.swift
//  FuelMaster
//
//  Created by Aura Silos on 22/12/21.
//

import UIKit

class PointView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    
    func configView(title: String?) {
        self.titleLabel.text = title!
        self.layer.cornerRadius = 10 
    }
    
    class func instanceFromNib() -> PointView {
        return UINib(nibName: "PointView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PointView
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
