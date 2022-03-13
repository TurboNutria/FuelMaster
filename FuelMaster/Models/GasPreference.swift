//
//  GasPreference.swift
//  FuelMaster
//
//  Created by Aura Silos on 28/12/21.
//

import Foundation

enum GasType: String, CaseIterable {
    case diesel = "Diesel"
    case gasoline = "Gasolina"
    case lpg = "GLP"
    case cng = "GNC"
    case lng = "GNL"
}

struct GasPreference {
    var type: GasType
    var selected: Bool
    
    init(type: GasType, selected: Bool) {
        
        self.type = type
        self.selected = selected
    }
}
