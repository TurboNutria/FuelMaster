//
//  MainListViewController.swift
//  FuelMaster
//
//  Created by Aura Silos on 4/11/21.
//

import Foundation
import CoreLocation
import UIKit

class MainListViewController: UITableViewController, CLLocationManagerDelegate, UISearchControllerDelegate, ShowMapDelegate, FavListDelegate, UISearchBarDelegate {
    
    var locationManager: CLLocationManager?
    lazy var searchBar =  UISearchController()
    var stationsList: [StationData]? = []
    var presenter: MainListPresenter = MainListPresenter()
    var mapView: MapViewController?
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.searchBar.placeholder = "Marca, ciudad, dirección..."
        self.navigationItem.searchController = searchBar
        self.tableView.reloadData()
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "headerColor")
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        self.tableView.setContentOffset(CGPoint(x: 0.0, y: -150.0), animated: false )
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "headerColor")
        self.navigationController?.navigationBar.prefersLargeTitles = true 
        NotificationCenter.default.addObserver(self, selector: #selector(sortData), name: NSNotification.Name("foundData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sortData), name: NSNotification.Name("refresh"), object: nil)
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        searchBar.delegate = self
        searchBar.searchBar.delegate = self
        let mainCellNib = UINib(nibName: "StationCell", bundle: nil)
        self.tableView.register(mainCellNib, forCellReuseIdentifier: "StationCell")
        let headerView = UINib(nibName: "ListHeaderView", bundle: nil)
        self.tableView.register(headerView, forHeaderFooterViewReuseIdentifier: "ListHeaderView")
        let toMapNib = UINib(nibName: "ShowMapCell", bundle: nil)
        self.tableView.register(toMapNib, forCellReuseIdentifier: "ShowMapCell")
        let favNib = UINib(nibName: "FavStationCell", bundle: nil)
        self.tableView.register(favNib, forCellReuseIdentifier: "FavStationCell")
        self.presenter.viewController = self
        self.presenter.viewDidLoad()
    }
    
    @objc func sortData() {
        
        self.presenter.viewDidLoad()
    }
    
    func foundData(data: [StationData]?) {
        
        if let d = data {
            
            self.stationsList = d
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func reloadOneSection(data: [StationData]?) {
        if let d = data {
            
            self.stationsList = d
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(integersIn: 2...2), with: .automatic)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ListHeaderView") as! ListHeaderView
        header.delegate = self 
        if section == 0 {
            
            header.backgroundView?.backgroundColor = .clear
            return nil
        } else if section == 1  {
            
            header.titleLabel.isHidden = false
            header.titleLabel.text = "Favoritas"
            header.sortButton.isHidden = true
            header.backgroundView?.backgroundColor = .clear
            return header
        } else {
            
            header.titleLabel.text = "Todas"
            header.titleLabel.isHidden = false
            header.sortButton.isHidden = false
            header.backgroundView?.backgroundColor = .clear
            return header
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            
            return 0
        } else {
            
            return 40.0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section <= 1 {
            
            return 1
        } else {
            
            return self.stationsList?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath) as! StationCell
            
            if let list = stationsList {
                
                cell.distanceLabel.text = String(list[indexPath.row].distanceToUser!).replacingOccurrences(of: ".", with: ",") + " km"
                cell.stationName.text = list[indexPath.row].owner!
                
                if let regGasPrice = list[indexPath.row].regularGasPrice {
                    
                    if regGasPrice == "" {
                        
                        cell.regularGasLabel.text = "Gasolina 95    -,---€"
                    } else {
                        
                        cell.regularGasLabel.text = "Gasolina 95    " +  regGasPrice + "€"
                    }
                }
                
                if let plusGasPrice = list[indexPath.row].superGasPrice {
                    
                    if plusGasPrice == "" {
                        
                        cell.superGasLabel.text = "Gasolina 98    -,---€"
                    } else {
                        
                        cell.superGasLabel.text = "Gasolina 98    " + plusGasPrice + "€"
                    }
                }
            }
            
            return cell
        } else if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowMapCell", for: indexPath) as! ShowMapCell
            
            cell.delegate = self
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavStationCell", for: indexPath) as! FavStationCell
            cell.locationManager = self.locationManager
            cell.delegate = self
            if !FavList.shared.stationList.isEmpty {
                
                cell.stationList = FavList.shared.stationList
                cell.reloadCollection()
            } else {
                
                cell.stationList = []
                cell.reloadCollection()
            }
            return cell
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            
            return 155.0
        } else {
            
            return tableView.estimatedRowHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let list = self.stationsList {
            
            self.tapStation(data: list[indexPath.row])
        }
    }
    
    func tapStation(data: StationData) {
        
        let vcN = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailViewNav") as! UINavigationController
        let vc = vcN.viewControllers.first as! StationDetailViewController
        vc.delegate = self
        vc.station = data
        present(vcN, animated: true, completion: nil)
    }
    
    func showMap() {
        
        if !splitViewController!.isCollapsed {
            
            if self.splitViewController?.displayMode == .oneBesideSecondary || self.splitViewController?.displayMode == .oneOverSecondary {
                let animations: () -> Void = {
                    self.splitViewController?.preferredDisplayMode = .secondaryOnly
                }
                UIView.animate(withDuration: 0.3, animations: animations, completion: nil)
                }
            } else {
                let split = splitViewController as! SplitViewControllerManager

                self.splitViewController?.showDetailViewController(split.mapView!, sender: nil)
                
            }
        }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let t = searchBar.text {
            
            if !t.isEmpty {
                
                searchData(text: t)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let t = searchBar.text {
            
            if !t.isEmpty {
                
                searchData(text: t)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.presenter.cancelFilter()
    }
    
    func searchData(text: String) {
        presenter.searchText(text: text)
    }
}

extension MainListViewController: StationDetialDelegate {
    func callToDeselect() {
        
    }
    
    func dismissDetailSheet() {
        self.tableView.reloadData()
    }
}

extension MainListViewController: HeaderProtocol {
    func tapSort(type: SortType) {
        switch type {
        case .distance:
            self.reloadOneSection(data: self.presenter.sortByDistance(list: self.stationsList!))
        case .price:
            self.reloadOneSection(data: self.presenter.sortByprice(list: self.stationsList!))
        }
    }
}
