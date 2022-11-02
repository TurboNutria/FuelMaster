//
//  GeocoderManager.swift
//  FuelMaster
//
//  Created by 600c-87481 on 31/3/22.
//

import Foundation
import SwiftReverseGeoCode

class GeocoderManager {
    static let path = Bundle.main.path(forResource: "geocitydb.sqlite", ofType: .none)

    static func getRegion(lat: Double, lon: Double) -> String {
        let reverseService = ReverseGeoCodeService(database: path!)
        do {
            
            let location = try reverseService.reverseGeoCode(latitude: lat, longitude: lon)
            let area = location.adminName.replacingOccurrences(of: "Provincia de ", with: "").replacingOccurrences(of: "Province of ", with: "").replacingOccurrences(of: "Província de ", with: "").replacingOccurrences(of: "Araba / ", with: "")
            print(area)
            return area
        } catch {
         
            return ""
        }
    }
    
}
