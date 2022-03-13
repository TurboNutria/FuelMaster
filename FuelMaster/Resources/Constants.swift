//
//  Constants.swift
//  FuelMaster
//
//  Created by Aura Silos on 4/11/21.
//

import Foundation

class Constants {
    
    static let APIURl: String = "https://sedeaplicaciones.minetur.gob.es/ServiciosRESTCarburantes/PreciosCarburantes/EstacionesTerrestres/"
    static let OneDay: Double = 86400
    static var filtersList: [MapFilterElement] = [MapFilterElement(type: .cheap, isSelected: true), MapFilterElement(type: .regular, isSelected: false), MapFilterElement(type: .expensice, isSelected: false), MapFilterElement(type: .all, isSelected: false)]
}
