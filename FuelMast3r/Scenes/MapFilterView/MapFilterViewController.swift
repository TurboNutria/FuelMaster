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
    var placemarkData: String = ""
    
    override func viewDidLoad() {
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        let nib = UINib(nibName: "MapFilterCell", bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: "MapFilterCell")
        
        if let locationManager = Constants.userLocation {
            if let actualLocation = locationManager.location {
                
                self.location = actualLocation
                self.placemarkData = GeocoderManager.getRegion(lat: actualLocation.coordinate.latitude, lon: actualLocation.coordinate.longitude)
            } else {
                
                self.location = CLLocation(latitude: 40.4165000,longitude: -3.7025600)
                self.placemarkData = GeocoderManager.getRegion(lat: self.location!.coordinate.latitude, lon: self.location!.coordinate.longitude)
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
        let manager = APIManager()
        if let locationmanager = Constants.displacedLication {
            
            manager.userLocation = locationmanager
            manager.changeMainList()
        } else {
            
            if let locationManager = Constants.userLocation,
               let location = locationManager.location {
                
                manager.userLocation = location
                manager.changeMainList()
            } else {
                
                manager.userLocation = CLLocation(latitude: 40.4165000, longitude: -3.7025600)
                manager.changeMainList()
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
    
    @IBAction func closeAction(_ sender: Any?) {
        
        self.dismiss(animated: true)
    }
    
}
