//
//  StationData.swift
//  FuelMaster
//
//  Created by Aura Silos on 4/11/21.
//

import Foundation

struct StationData: Codable {
    
    let postalCode: String?
    let address: String?
    let openingHours: String?
    let city: String?
    let latitude: String
    var latitudeDouble: Double {
        get {
            
            let formattedString = latitude.replacingOccurrences(of: ",", with: ".")
            if let latDouble = Double(formattedString) {
                
                return latDouble
            } else {
                
                return 0.0
            }
        }
    }
    let longitude: String?
    var longitudeDouble: Double {
        get {
            
            if let lon = longitude {
                let formattedString = lon.replacingOccurrences(of: ",", with: ".")
                if let latDouble = Double(formattedString) {
                    
                    return latDouble
                } else {
                    
                    return 0.0
                }
            } else {
                
                return 0.0
            }
        }
    }
    let municipality: String?
    let bioDieselPrice: String?
    let bioEthanolPrice: String?
    let cngPrice: String?
    let lngPrice: String?
    let lpgPrice: String?
    let regularDieselPrice: String?
    let farmDieselPrice: String?
    let premiumDieselPrice: String?
    let regularGasPrice: String?
    let premiumGasPrice: String?
    let superGasPrice: String?
    let hydrogenPrice: String?
    let province: String?
    let owner: String?
    let bioEthanolPercentage: String?
    let esterPercentage: String?
    var distanceToUser: Double?
    var IDCCAA: String?
    var IDEESS: String?
    
    enum CodingKeys: String, CodingKey {
        case postalCode = "C.P."
        case address = "Dirección"
        case openingHours = "Horario"
        case city = "Localidad"
        case latitude = "Latitud"
        case longitude = "Longitud (WGS84)"
        case municipality = "Municipio"
        case bioDieselPrice = "Precio Biodiesel"
        case bioEthanolPrice = "Precio Bioetanol"
        case cngPrice = "Precio Gas Natural Comprimido"
        case lngPrice = "Precio Gas Natural Licuado"
        case lpgPrice = "Precio Gases licuados del petróleo"
        case regularDieselPrice = "Precio Gasoleo A"
        case farmDieselPrice = "Precio Gasoleo B"
        case premiumDieselPrice = "Precio Gasoleo Premium"
        case regularGasPrice = "Precio Gasolina 95 E5"
        case premiumGasPrice = "Precio Gasolina 95 E5 Premium"
        case superGasPrice = "Precio Gasolina 98 E5"
        case hydrogenPrice = "Precio Hidrogeno"
        case province = "Provincia"
        case owner = "Rótulo"
        case bioEthanolPercentage = "% BioEtanol"
        case esterPercentage = "% Éster metílico"
        case IDCCAA = "IDCCAA"
        case IDEESS = "IDEESS"
        
    }
    
    
}
