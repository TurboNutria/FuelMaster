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
        self.sortedList.removeAll()
        self.sortedByDistance.removeAll()
        self.sortedByPrice.removeAll()
        self.currentList.removeAll()
        interactor.presenter = self
        
        if !ResponseData.shared.userRegional.isEmpty {
            
            self.foundData(data: ResponseData.shared)
        }
    }
    
    func searchText(text: String) {
        let byTownList = self.currentList.filter { data in
            
            if let city = data.city {
                
                return city.capitalized.contains(text.capitalized)
            } else {
                
                return false
            }
        }
        
        let byOwnerList = self.currentList.filter { data in
            
            if let owner = data.owner {
                
                return owner.capitalized.contains(text.capitalized)
            } else {
                
                return false
            }
        }
        
        let byProvinceList = self.currentList.filter { data in
            
            if let province = data.province {
                
                return province.capitalized.contains(text.capitalized)
            } else {
                
                return false 
            }
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
        if let vc = viewController {
            
            if vc.isCheap {
                
                self.viewController?.foundData(data: self.sortByprice(list: currentList))
            } else {
                
                self.viewController?.foundData(data: self.sortByDistance(list: currentList))
            }
        }
    }
    
    func foundData(data: ResponseData?) {
        if let d = data?.userRegional {
            for i in d {
                
                if viewController?.locationManager?.authorizationStatus == .authorizedWhenInUse || viewController?.locationManager?.authorizationStatus == .authorizedAlways {
                 
                    if let vC = viewController,
                       let lM = vC.locationManager,
                       let location = lM.location {
                        
                        sortedList.append(i)
                        let distance = CLLocation.distance(from: location.coordinate , to: CLLocationCoordinate2D(latitude: i.latitudeDouble, longitude: i.longitudeDouble))
                        let roundedValue = round((distance / 1000) * 100) / 100.0
                        sortedList[sortedList.endIndex - 1].distanceToUser = (roundedValue)
                    }
                }
            }
        }
               
        self.sortedByDistance = filterUserDistance(list: sortedList)
        
        self.sortedByPrice = sortByprice(list: sortedByDistance)
        
        self.currentList = sortedByPrice.filter { data in
            
            if let gasType = UserDefaults.standard.value(forKey: "gasType") as? String,
            let gasCase = GasType(rawValue: gasType) {
                switch gasCase {
                case .diesel:
                    return data.regularDieselPrice! != ""
                case .gasoline:
                    return data.regularGasPrice! != ""
                case .lpg:
                    return data.lpgPrice! != ""
                case .cng:
                    return data.cngPrice! != ""
                case .lng:
                    return data.lngPrice! != ""
                }
            } else {
                
                return data.regularGasPrice! != ""
            }
        }
        if let vc = viewController {
            
            if vc.isCheap {
                
                self.viewController?.foundData(data: self.sortByprice(list: currentList))
            } else {
                
                self.viewController?.foundData(data: self.sortByDistance(list: currentList))
            }
        }
    }
    
    func filterUserDistance(list: [StationData]) -> [StationData] {
        let sortedByDistanceList = list.filter { data in
            
            if let distance = data.distanceToUser {
                
                return distance < 11.0
            } else {
                
                return false
            }
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
                    
            if let gasType = UserDefaults.standard.value(forKey: "gasType") as? String,
            let gasCase = GasType(rawValue: gasType) {
                switch gasCase {
                case .diesel:
                    return Double($0.regularDieselPrice!.replacingOccurrences(of: ",", with: ".")) ?? 0.0 < Double($1.regularDieselPrice!.replacingOccurrences(of: ",", with: ".")) ?? 0.0

                case .gasoline:
                    return Double($0.regularGasPrice!.replacingOccurrences(of: ",", with: ".")) ?? 0.0 < Double($1.regularGasPrice!.replacingOccurrences(of: ",", with: ".")) ?? 0.0

                case .lpg:
                    return Double($0.lpgPrice!.replacingOccurrences(of: ",", with: ".")) ?? 0.0 < Double($1.lpgPrice!.replacingOccurrences(of: ",", with: ".")) ?? 0.0

                case .cng:
                    return Double($0.cngPrice!.replacingOccurrences(of: ",", with: ".")) ?? 0.0 < Double($1.cngPrice!.replacingOccurrences(of: ",", with: ".")) ?? 0.0

                case .lng:
                    return Double($0.lngPrice!.replacingOccurrences(of: ",", with: ".")) ?? 0.0 < Double($1.lngPrice!.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                }
            } else {
                
                return Double($0.regularGasPrice!.replacingOccurrences(of: ",", with: ".")) ?? 0.0 < Double($1.regularGasPrice!.replacingOccurrences(of: ",", with: ".")) ?? 0.0
            }
        }
        
        return sortedByPrice
    }
}
