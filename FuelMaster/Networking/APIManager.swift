//
//  APIManager.swift
//  FuelMaster
//
//  Created by Aura Silos on 4/11/21.
//

import Foundation
import CoreLocation

class APIManager {
    var placemarkData: CLPlacemark?
    var userLocation: CLLocation?
    
    func getDataFromMinisty(result: @escaping( _ output: ResponseData?) -> Void) {

        if let url = URL(string: Constants.APIURl) {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                  do {
                     let res = try JSONDecoder().decode(ResponseData.self, from: data)
                      ResponseData.shared.stationList = res.stationList
                      result(res)
                  } catch let error {
                     print(error)
                  }
               }
           }.resume()
        }
    }
    
    func changeMainList() {
            if let actualLocation = userLocation {
                
                CLGeocoder().reverseGeocodeLocation(actualLocation) { placemarkList, error in
                    if error == nil {
                        if let placemark = placemarkList {
                            if placemark.count > 0 {
                                
                                self.placemarkData = placemark[0]
                                let average = ResponseData.shared.average
                                
                                let currentValue = (Constants.filtersList.first { element in
                                    return element.isSelected
                                })?.priceType
                                
                                let modList = ResponseData.shared.regularList.filter { element in
                                    
                                    if element.regularGasPrice != "" {
                                        
                                        if let priceDouble = Double(element.regularGasPrice!.replacingOccurrences(of: ",", with: ".")) {
                                            
                                            switch currentValue {
                                            case .cheap:
                                                if priceDouble <= average - 0.06 {
                                                    
                                                    return true
                                                } else {
                                                    
                                                    return false
                                                }
                                            case .regular:
                                                if priceDouble > average - 0.06 && priceDouble < average + 0.06 {
                                                    
                                                    return true
                                                } else {
                                                    
                                                    return false
                                                }
                                            case .expensice:
                                                if priceDouble >= average + 0.06 {
                                                    
                                                    return true
                                                } else {
                                                    
                                                    return false
                                                }
                                            case .all:
                                                if let province = element.province,
                                                   let placermark = self.placemarkData,
                                                   let userProvince = placermark.administrativeArea {
                                                    
                                                    if province.contains(self.verifyProvince(userProvince).uppercased()) {
                                                        
                                                        return true
                                                    } else {
                                                        
                                                        return false
                                                    }
                                                } else {
                                                    
                                                    return false
                                                }
                                            case .none:
                                                if priceDouble <= average - 0.06 {
                                                    
                                                    return true
                                                } else {
                                                    
                                                    return false
                                                }
                                            }
                                        } else {
                                            
                                            return false
                                        }
                                    } else {
                                        
                                        return false
                                    }
                                }
                                ResponseData.shared.stationList.removeAll()
                                ResponseData.shared.stationList = modList
                                NotificationCenter.default.post(name: NSNotification.Name("update"), object: nil)
                            }
                        }
                    }
                }
            }
        
    }
    
    func verifyProvince(_ provinceToCheck: String) -> String {
        if provinceToCheck.uppercased().contains("CORUÑA") {
            
            return "CORUÑA"
        } else if provinceToCheck.uppercased().contains("GERONA") {
            
            return "GIRONA"
        } else if provinceToCheck.uppercased().contains("BALEARES") {
            
            return "BALEARS"
        } else if provinceToCheck.uppercased().contains("LERIDA") {
            
            return "LLEIDA"
        } else if provinceToCheck.uppercased().contains("GUIPUZ") {
            
            return "GIPUZKOA"
        } else if provinceToCheck.uppercased().contains("VIZ") {
            
            return "BIZKAIA"
        } else {
            
            return provinceToCheck
        }
        
    }
}
