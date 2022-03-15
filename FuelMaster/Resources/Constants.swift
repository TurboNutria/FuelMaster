//
//  Constants.swift
//  FuelMaster
//
//  Created by Aura Silos on 4/11/21.
//

import Foundation
import CoreLocation

class Constants {
    
    static let APIURl: String = "https://sedeaplicaciones.minetur.gob.es/ServiciosRESTCarburantes/PreciosCarburantes/EstacionesTerrestres/"
    static let OneDay: Double = 86400
    static var filtersList: [MapFilterElement] = [MapFilterElement(type: .cheap, isSelected: false), MapFilterElement(type: .regular, isSelected: false), MapFilterElement(type: .expensice, isSelected: false), MapFilterElement(type: .all, isSelected: true)]
    static var userLocation: CLLocationManager?
    static var currentUserProvince: String = "MADRID"
    static let ownersList: [String] = ["CEPSA","REPSOL","BONAREA","BP","PETRONOR","CAMPSA","SHELL","GALP","PLENOIL","ESCLATOIL","PETROPRIX","BALLENOIL","CARREFOUR","ALCAMPO","E.LECLERC","MEROIL","AVIA","VALCARCE"]
}
