//
//  MapFilterElement.swift
//  FuelMaster
//
//  Created by 600c-87481 on 12/3/22.
//

import Foundation

enum MapFilterType: String {
    case cheap = "Económicas"
    case regular = "En la media"
    case expensice = "Caras"
    case all = "Todas"
}

struct MapFilterElement {
    
    var priceType: MapFilterType = .cheap
    var isSelected: Bool = false
    
    init (type: MapFilterType, isSelected: Bool) {
        
        self.priceType = type
        self.isSelected = isSelected
    }
}
