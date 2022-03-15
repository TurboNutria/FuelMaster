//
//  MapFilterViewController.swift
//  FuelMaster
//
//  Created by 600c-87481 on 12/3/22.
//

import Foundation
import UIKit
import CoreLocation

protocol MapFilterViewDelegate: AnyObject {
    func filterSelected()
}

class MapFilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView?
    
    weak var delegate: MapFilterViewDelegate?
    var location: CLLocation?
    var placemarkData: CLPlacemark?
    
    override func viewDidLoad() {
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        let nib = UINib(nibName: "MapFilterCell", bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: "MapFilterCell")
        
        if let locationManager = Constants.userLocation {
            if let actualLocation = locationManager.location {
                
                self.location = actualLocation
                CLGeocoder().reverseGeocodeLocation(actualLocation) { placemarkList, error in
                    if error == nil {
                        if let placemark = placemarkList {
                            if placemark.count > 0 {
                                
                                self.placemarkData = placemark[0]
                            }
                        }
                    }
                }
            } else {
                CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: 40.4165000,longitude: -3.7025600)) { placemarkList, error in
                    if error == nil {
                        if let placemark = placemarkList {
                            if placemark.count > 0 {
                                
                                self.placemarkData = placemark[0]
                            }
                        }
                    }
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapFilterCell", for: indexPath) as! MapFilterCell
        cell.filterDescription.text = Constants.filtersList[indexPath.item].priceType.rawValue
        cell.filterSelected.isHidden = !Constants.filtersList[indexPath.item].isSelected
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.filtersList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = Constants.filtersList.firstIndex(where: { element in
            return element.isSelected
        }) {
            Constants.filtersList[index].isSelected = false
        }
        
        Constants.filtersList[indexPath.item].isSelected = true
        self.changeMainList()
        self.delegate?.filterSelected()
        self.dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Precios"
    }
    
    func changeMainList() {
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
                            
                            if province.contains(verifyProvince(userProvince).uppercased()) {
                                
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
    
    @IBAction func closeAction(_ sender: Any?) {
        
        self.dismiss(animated: true)
    }
    
}
