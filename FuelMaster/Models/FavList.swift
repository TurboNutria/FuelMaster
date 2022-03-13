//
//  FavList.swift
//  FuelMaster
//
//  Created by Aura Silos on 22/12/21.
//

import Foundation

struct FavList {
    var stationList: [StationData]
    
    static var shared = FavList(list: [])
    
    private init (list: [StationData]) {
        self.stationList = list
    }
}
