//
//  StationData.swift
//  FuelMaster
//
//  Created by Aura Silos on 4/11/21.
//

import Foundation

struct ResponseData: Codable {
    var stationList: [StationData]
    var regularList: [StationData] = []
    
    static var shared = ResponseData(list: [])
    var average: Double = 0.0
    
    private init (list: [StationData]) {
        self.stationList = list
    }
    
    enum CodingKeys: String, CodingKey {
        case stationList = "ListaEESSPrecio"
    }
}
