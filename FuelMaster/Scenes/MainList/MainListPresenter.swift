//
//  MainListController.swift
//  FuelMaster
//
//  Created by Aura Silos on 4/11/21.
//

import Foundation
import CoreLocation

class MainListPresenter: APIManagerOutput {

    var viewController: MainListViewController?
    var interactor: APIManagerInteractor = APIManagerInteractor()
    var sortedList: [StationData] = []
    var sortedByDistance: [StationData] = []
    var sortedByPrice: [StationData] = []
    var currentList: [StationData] = []
    
    func viewDidLoad() {
        interactor.presenter = self
        
        if !ResponseData.shared.stationList.isEmpty {
            
            self.foundData(data: ResponseData.shared)
        }
    }
    
    func searchText(text: String) {
        let byTownList = self.currentList.filter { data in
            
            return data.city?.capitalized == text.capitalized
        }
        
        let byOwnerList = self.currentList.filter { data in
            
            return data.owner?.capitalized == text.capitalized
        }
        
        let byProvinceList = self.currentList.filter { data in
            
            return data.province?.capitalized == text.capitalized
        }
        
        let byAddressList = self.currentList.filter { data in
            
            return (data.address?.capitalized.contains(text.capitalized))!
        }
        
        let byCpList = self.currentList.filter { data in
            
                
            return data.postalCode == text
        }
        
        if !byTownList.isEmpty {
            
            self.viewController?.foundData(data: sortByDistance(list: byTownList))
        } else if !byOwnerList.isEmpty {
            
            self.viewController?.foundData(data: sortByDistance(list: byOwnerList))
        } else if !byProvinceList.isEmpty {
            
            self.viewController?.foundData(data: sortByDistance(list: byProvinceList))
        } else if !byAddressList.isEmpty {
            
            self.viewController?.foundData(data: sortByDistance(list: byAddressList))
        } else if !byCpList.isEmpty {
            
            self.viewController?.foundData(data: sortByDistance(list: byCpList))
        }
    }
    
    func cancelFilter() {
        
        self.viewController?.foundData(data: currentList)
    }
    
    func foundData(data: ResponseData?) {
        if let d = data?.stationList {
            for i in d {
                
                sortedList.append(i)
                
                let distance = CLLocation.distance(from: (viewController?.locationManager?.location!.coordinate)! , to: CLLocationCoordinate2D(latitude: i.latitudeDouble, longitude: i.longitudeDouble))
                let roundedValue = round((distance / 2000) * 200) / 200.0
                sortedList[sortedList.endIndex - 1].distanceToUser = (roundedValue)
            }
        }
               
        self.sortedByDistance = filterUserDistance(list: sortedList)
        
        self.sortedByPrice = sortByprice(list: sortedByDistance)
        
        self.currentList = sortedByPrice.filter { data in
            
            return data.regularGasPrice! != ""
        }
        
        self.viewController?.foundData(data: currentList)
    }
    
    func filterUserDistance(list: [StationData]) -> [StationData] {
        let sortedByDistanceList = list.filter { data in
            
            return data.distanceToUser! < 11.0
        }

        return sortedByDistanceList
    }
    
    func sortByDistance(list: [StationData]) -> [StationData] {
        let sortedList = list.sorted {
            
            return $0.distanceToUser! < $1.distanceToUser!
        }
        
        return sortedList
    }
    
    func sortByprice(list: [StationData]) -> [StationData] {
        let sortedByPrice = list.sorted {
                    
            return Double($0.regularGasPrice!.replacingOccurrences(of: ",", with: ".")) ?? 0.0 < Double($1.regularGasPrice!.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        }
        
        return sortedByPrice
    }
}
