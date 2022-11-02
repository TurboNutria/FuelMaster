//
//  APIManager.swift
//  FuelMaster
//
//  Created by Aura Silos on 4/11/21.
//

import Foundation
import CoreLocation
import MapKit

class APIManager {
    var placemarkData: String?
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
    
    func setRegionalArea() {
        
        Constants.currentUserProvince = GeocoderManager.getRegion(lat: (self.userLocation?.coordinate.latitude)!, lon: (self.userLocation?.coordinate.longitude)!)
        let regionalList = ResponseData.shared.regularList.filter { element in
            if let province = element.province
                {
                let userProvince = Constants.currentUserProvince
                if province.contains(self.verifyProvince(userProvince).uppercased()) {
                    
                    return true
                } else {
                    
                    return false
                }
            } else {
                
                return false
            }

        }
        ResponseData.shared.userRegional = regionalList
    }
    
    func changeMainList() {
            if let actualLocation = userLocation {
                
                self.placemarkData = GeocoderManager.getRegion(lat: actualLocation.coordinate.latitude, lon: actualLocation.coordinate.longitude)
                    self.recalculateAverage()
                    let average = ResponseData.shared.average
                    
                    let currentValue = (Constants.filtersList.first { element in
                        return element.isSelected
                    })?.priceType
                    
                    if !UserDefaults.standard.bool(forKey: "regional") {
                        
                        let regionalList = ResponseData.shared.regularList.filter { element in
                            if let province = element.province,
                               let placermark = self.placemarkData {
                                
                                let userProvince = placermark
                                if province.contains(self.verifyProvince(userProvince).uppercased()) {
                                    
                                    return true
                                } else {
                                    
                                    return false
                                }
                            } else {
                                
                                return false
                            }

                        }
                        
                        ResponseData.shared.regionalList = regionalList
                        UserDefaults.standard.set(true, forKey: "regional")
                    }
                    
                    
                    let modList = ResponseData.shared.regionalList.filter { element in
                        if let gasType = UserDefaults.standard.value(forKey: "gasType") as? String,
                        let gasCase = GasType(rawValue: gasType) {
                            
                            switch gasCase {
                            case .diesel:
                                if element.regularDieselPrice != "" {
                                    
                                    return self.changeFilterType(element: element.regularDieselPrice ?? "0,0", oProvince: element.province, currentValue: currentValue ?? .all, average: average)
                                } else {
                                    
                                    return false
                                }
                            case .gasoline:
                                if element.regularGasPrice != "" {
                                    
                                    return self.changeFilterType(element: element.regularGasPrice ?? "0,0", oProvince: element.province, currentValue: currentValue ?? .all, average: average)
                                } else {
                                    
                                    return false
                                }
                            case .lpg:
                                if element.lpgPrice != "" {
                                    
                                    return self.changeFilterType(element: element.lpgPrice ?? "0,0", oProvince: element.province, currentValue: currentValue ?? .all, average: average)
                                } else {
                                    
                                    return false
                                }
                            case .cng:
                                if element.cngPrice != "" {
                                    
                                    return self.changeFilterType(element: element.cngPrice ?? "0,0", oProvince: element.province, currentValue: currentValue ?? .all, average: average)
                                } else {
                                    
                                    return false
                                }
                            case .lng:
                                if element.lngPrice != "" {
                                    
                                    return self.changeFilterType(element: element.lngPrice ?? "0,0", oProvince: element.province, currentValue: currentValue ?? .all, average: average)
                                } else {
                                    
                                    return false
                                }
                            }
                        } else {
                            
                            if let province = element.province,
                               let placermark = self.placemarkData
                                {
                                let userProvince = placermark
                                if province.contains(self.verifyProvince(userProvince).uppercased()) {
                                    
                                    return true
                                } else {
                                    
                                    return false
                                }
                            } else {
                                
                                return false
                            }
                        }
                    }
                    ResponseData.shared.stationList.removeAll()
                    ResponseData.shared.stationList = modList
                    NotificationCenter.default.post(name: NSNotification.Name("update"), object: nil)
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
        } else if provinceToCheck.uppercased().contains("SARAGOSSA") {
            
            return "ZARAGOZA"
        } else if provinceToCheck.uppercased().contains("CADIZ") {
            
            return "CÁDIZ"
        } else if provinceToCheck.uppercased().contains("JAEN") {
            
            return "JAÉN"
        } else if provinceToCheck.uppercased().contains("CORDOBA") {
            
            return "CÓRDOBA"
        }  else if provinceToCheck.uppercased().contains("MALAGA") {
            
            return "MÁLAGA"
        }  else if provinceToCheck.uppercased().contains("LEON") {
            
            return "LEÓN"
        }  else if provinceToCheck.uppercased().contains("AVILA") {
            
            return "ÁVILA"
        }  else if provinceToCheck.uppercased().contains("RIOJA") {
            
            return "RIOJA"
        } else if provinceToCheck.uppercased().contains("CACERES") {
            
            return "CÁCERES"
        }  else if provinceToCheck.uppercased().contains("ALMERIA") {
            
            return "ALMERÍA"
        }  else {
            
            return provinceToCheck
        }
        
    }
    
    func changeFilterType(element: String, oProvince: String?, currentValue: MapFilterType, average: Double) -> Bool {
            
            if let priceDouble = Double(element.replacingOccurrences(of: ",", with: ".")) {
                
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
                    if let province = oProvince,
                       let placermark = self.placemarkData
                        {
                        let userProvince = placermark
                        if province.contains(self.verifyProvince(userProvince).uppercased()) {
                            
                            return true
                        } else {
                            
                            return false
                        }
                    } else {
                        
                        return false
                    }
                }
            } else {
                
                return false
            }
        }
    
    func recalculateAverage() {
        var priceArray: [Double] = []
    
        for element in ResponseData.shared.regularList {
            
            if let gasType = UserDefaults.standard.value(forKey: "gasType") as? String,
            let gasCase = GasType(rawValue: gasType) {
                switch gasCase {
                case .diesel:
                    if let price = element.regularDieselPrice,
                       let priceDouble = Double(price.replacingOccurrences(of: ",", with: ".")),
                       let province = element.province {
                        
                        if !province.uppercased().contains("TENERIFE") || !province.uppercased().contains("PALMAS") || !province.uppercased().contains("CEUTA") || !province.uppercased().contains("MELILLA") {
                            
                            priceArray.append(priceDouble)
                        }
                    }
                case .gasoline:
                    if let price = element.regularGasPrice,
                       let priceDouble = Double(price.replacingOccurrences(of: ",", with: ".")),
                       let province = element.province {
                        
                        if !province.uppercased().contains("TENERIFE") || !province.uppercased().contains("PALMAS") || !province.uppercased().contains("CEUTA") || !province.uppercased().contains("MELILLA") {
                            
                            priceArray.append(priceDouble)
                        }
                    }
                case .lpg:
                    if let price = element.lpgPrice,
                       let priceDouble = Double(price.replacingOccurrences(of: ",", with: ".")),
                       let province = element.province {
                        
                        if !province.uppercased().contains("TENERIFE") || !province.uppercased().contains("PALMAS") || !province.uppercased().contains("CEUTA") || !province.uppercased().contains("MELILLA") {
                            
                            priceArray.append(priceDouble)
                        }
                    }
                case .cng:
                    if let price = element.cngPrice,
                       let priceDouble = Double(price.replacingOccurrences(of: ",", with: ".")),
                       let province = element.province {
                        
                        if !province.uppercased().contains("TENERIFE") || !province.uppercased().contains("PALMAS") || !province.uppercased().contains("CEUTA") || !province.uppercased().contains("MELILLA") {
                            
                            priceArray.append(priceDouble)
                        }
                    }
                case .lng:
                    if let price = element.lngPrice,
                       let priceDouble = Double(price.replacingOccurrences(of: ",", with: ".")),
                       let province = element.province {
                        
                        if !province.uppercased().contains("TENERIFE") || !province.uppercased().contains("PALMAS") || !province.uppercased().contains("CEUTA") || !province.uppercased().contains("MELILLA") {
                            
                            priceArray.append(priceDouble)
                        }
                    }
                }
            } else {
                if let price = element.regularGasPrice,
                   let priceDouble = Double(price.replacingOccurrences(of: ",", with: ".")),
                   let province = element.province {
                    
                    if !province.uppercased().contains("TENERIFE") || !province.uppercased().contains("PALMAS") || !province.uppercased().contains("CEUTA") || !province.uppercased().contains("MELILLA") {
                        
                        priceArray.append(priceDouble)
                    }
                }
            }
        }
        
        let average = priceArray.reduce(0.0) {
            return $0 + $1/Double(priceArray.count)
        }
        
        ResponseData.shared.average = average
    }
}
