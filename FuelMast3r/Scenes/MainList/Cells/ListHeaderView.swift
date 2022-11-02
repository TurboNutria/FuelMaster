//
//  ListHeaderView.swift
//  FuelMaster
//
//  Created by Aura Silos on 7/11/21.
//

import UIKit

enum SortType {
    case distance
    case price
}

protocol HeaderProtocol: AnyObject {
    func tapSort(type: SortType)
}

class ListHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sortButton: UIButton!
    
    weak var delegate: HeaderProtocol?

    override func awakeFromNib() {
        let priceAction = UIAction(title: "Precio", image: nil) { _ in
            
            self.sortByPrice()
        }
        
        let distanceAction = UIAction(title: "Distancia", image: nil) { _ in
            
            self.sortByDistance()
        }
        
        let menu = UIMenu(title: "Ordenar", image: nil, identifier: UIMenu.Identifier("ordenar"), options: [.singleSelection,.displayInline], children: [priceAction,distanceAction])
        self.sortButton.menu = menu
    }
    
    @objc func sortByDistance() {
        self.delegate?.tapSort(type: .distance)
    }
    
    @objc func sortByPrice() {
        self.delegate?.tapSort(type: .price)
    }
    
}
