//
//  MapViewController.swift
//  FuelMaster
//
//  Created by Aura Silos on 4/11/21.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import CoreLocationUI

class MapViewController: UIViewController, MKMapViewDelegate, StationDetialDelegate, MapFilterViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var locationButton: CLLocationButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var stationsList: [StationData]? = []
    var detailView: StationDetailViewController?
    var selectedPin: MKAnnotationView?
    var locationManager: CLLocationManager?
    var currentAnnotations: [MKAnnotation] = []
    var selectStatus = false

    override func viewDidLoad() {
        self.map.alpha = 0.5
        self.map.isUserInteractionEnabled = false
        self.map.userTrackingMode = .followWithHeading
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        self.map.delegate = self
        self.title = "Mapa"
        self.parent?.navigationController?.navigationBar.prefersLargeTitles = false
        self.parent?.navigationController?.navigationBar.barTintColor = UIColor(named: "fontColor")
        self.parent?.navigationController?.navigationBar.backgroundColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataFound), name: NSNotification.Name("foundData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMap), name: NSNotification.Name("refresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMap), name: NSNotification.Name("update"), object: nil)
        let navButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), landscapeImagePhone: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: #selector(filterAction))
        self.navigationItem.rightBarButtonItem = navButton
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapOutside))
//        self.map.addGestureRecognizer(tap)
        self.map.showsUserLocation = true
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationButton.addTarget(self, action: #selector(userPressedLocationButton), for: .touchUpInside)
        Constants.userLocation = locationManager
        if locationManager?.authorizationStatus == .authorizedWhenInUse {
            self.centerMapOnLocation(location: (locationManager?.location)!)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let split = splitViewController as! SplitViewControllerManager
        split.mapView = self
        if let vc = detailView {
            
            vc.dismiss(animated: true) {
                
                self.dismissDetailSheet()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.4) {
            self.parent?.navigationController?.navigationBar.prefersLargeTitles = false
        }
        self.parent?.navigationController?.navigationBar.prefersLargeTitles = false
        self.parent?.navigationController?.navigationBar.barTintColor = UIColor(named: "fontColor")
        self.parent?.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    @objc func refreshMap() {
        if let originalDate = UserDefaults.standard.value(forKey: "backgroundDate") as? Date {
            
            let currentDate = Date()
            if DateInterval(start: originalDate, end: currentDate).duration >= Constants.OneDay {
                DispatchQueue.main.async {
                    
//                    self.map.alpha = 0.5
//                    self.map.isUserInteractionEnabled = false
//                    self.activityIndicator.startAnimating()
                }
            } else {
                
                DispatchQueue.main.async {
//                    self.centerMapOnLocation(location: (self.locationManager?.location)!)
                }
            }
        } else {
            
            DispatchQueue.main.async {
//                self.centerMapOnLocation(location: (self.locationManager?.location)!)
            }

        }
    }
    
    @objc func updateMap() {
        
        self.map.removeAnnotations(self.currentAnnotations)
        DispatchQueue.main.async {
       let data = ResponseData.shared.stationList
         let d = data
            for i in d {
                
                let annotation = MKPointAnnotation()
                if let gasType = UserDefaults.standard.value(forKey: "gasType") as? String,
                let gasCase = GasType(rawValue: gasType) {
                    
                    switch gasCase {
                    case .diesel:
                        annotation.title = "\(i.owner ?? "DESCONOCIDO") - \(i.regularDieselPrice ?? "--")€"
                    case .gasoline:
                        annotation.title = "\(i.owner ?? "DESCONOCIDO") - \(i.regularGasPrice ?? "--")€"
                    case .lpg:
                        annotation.title = "\(i.owner ?? "DESCONOCIDO") - \(i.lpgPrice ?? "--")€"
                    case .cng:
                        annotation.title = "\(i.owner ?? "DESCONOCIDO") - \(i.cngPrice ?? "--")€"
                    case .lng:
                        annotation.title = "\(i.owner ?? "DESCONOCIDO") - \(i.lngPrice ?? "--")€"
                    }
                } else {
                    
                    annotation.title = "\(i.owner ?? "DESCONOCIDO") - \(i.regularGasPrice ?? "--")€"
                }
                annotation.subtitle = i.address
                annotation.coordinate = CLLocationCoordinate2D(latitude: Double(i.latitude.replacingOccurrences(of: ",", with: "."))!, longitude: Double(i.longitude!.replacingOccurrences(of: ",", with: "."))!)
                    
                    self.currentAnnotations.append(annotation)
                    self.map.addAnnotation(annotation)
            }
            self.activityIndicator.stopAnimating()
            self.map.alpha = 1.0
            self.map.isUserInteractionEnabled = true
        }
    }
    
    @objc func dataFound() {
        let manager = APIManager()
        let status = locationManager?.authorizationStatus
        print(status!.rawValue)
        if status == .authorizedWhenInUse  || status == .authorizedAlways || status == .restricted {
            manager.userLocation = self.locationManager?.location
            manager.changeMainList()
            self.centerMapOnLocation(location: (locationManager?.location)!)
        } else if status == .denied {
            manager.userLocation = CLLocation(latitude: 40.4165000, longitude: -3.7025600)
            manager.changeMainList()
            self.centerMapOnLocation(location: CLLocation(latitude: 40.4165000, longitude: -3.7025600))
        } else {
        }
    }
    
    func callToDeselect() {
        self.map.deselectAnnotation(self.selectedPin?.annotation, animated: true)
    }
    
    @objc func tapOutside() {
        self.map.deselectAnnotation(self.selectedPin?.annotation, animated: true)
//        self.dismissDetailSheet()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation,
           let title = annotation.title {
            if !(title == "My Location") {
                self.selectedPin = view
                self.centerMapOnLocation(location: CLLocation(latitude: (view.annotation?.coordinate.latitude)! - 0.006, longitude: (view.annotation?.coordinate.longitude)!))
                if let vc = self.detailView {

                    self.configureDetailSheet(vc: vc.parent!, source: view)
                    let station = ResponseData.shared.stationList.filter { data in
                            
                        return data.address == view.annotation?.subtitle
                    }
                    vc.station = station.first
                    vc.updateStation()
                } else {
                    let vcN = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailViewNav") as! UINavigationController
                    let vc = vcN.viewControllers.first as! StationDetailViewController
                    
                    self.configureDetailSheet(vc: vcN, source: view)
                    vc.title = view.annotation?.title!
                    vc.titleLabel = (view.annotation?.title!)!
                    vc.navigationItem.title = view.annotation?.title!
                    self.detailView = vc
                    vc.delegate = self
                    let station = ResponseData.shared.stationList.filter { data in
                        
                        return data.address == view.annotation?.subtitle
                    }
                    vc.station = station.first
                    present(vcN, animated: true, completion: nil)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKMarkerAnnotationView? = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        let station = ResponseData.shared.stationList.filter { data in
            return data.address == annotation.subtitle
        }
        if let stationData = station.first {
            
            annotationView?.glyphImage = UIImage(systemName: "fuelpump.circle")
            if let gasType = UserDefaults.standard.value(forKey: "gasType") as? String,
            let gasCase = GasType(rawValue: gasType) {
                switch gasCase {
                case .diesel:
                    if let price = stationData.regularDieselPrice {
                        
                        if let priceInt = Double(price.replacingOccurrences(of: ",", with: ".")) {
                            
                            if priceInt <= ResponseData.shared.average - 0.06 {
                                
                                annotationView?.markerTintColor = UIColor(red: (51.0/255), green: (161.0/255), blue: (79.0/255), alpha: 1.0)

                            } else if priceInt >= ResponseData.shared.average - 0.05 && priceInt <= ResponseData.shared.average + 0.05 {
                                
                                annotationView?.markerTintColor = UIColor(red: (249.0/255), green: (126.0/255), blue: (43.0/255), alpha: 1.0)

                            } else {
                                
                                annotationView?.markerTintColor = UIColor(red: (247.0/255), green: (75.0/255), blue: (36.0/255), alpha: 1.0)

                            }
                        }
                    } else {
                        
                        annotationView?.markerTintColor = UIColor.gray
                        
                        }

                case .gasoline:
                    if let price = stationData.regularGasPrice {
                        
                        if let priceInt = Double(price.replacingOccurrences(of: ",", with: ".")) {
                            
                            if priceInt <= ResponseData.shared.average - 0.06 {
                                
                                annotationView?.markerTintColor = UIColor(red: (51.0/255), green: (161.0/255), blue: (79.0/255), alpha: 1.0)

                            } else if priceInt >= ResponseData.shared.average - 0.05 && priceInt <= ResponseData.shared.average + 0.05 {
                                
                                annotationView?.markerTintColor = UIColor(red: (249.0/255), green: (126.0/255), blue: (43.0/255), alpha: 1.0)

                            } else {
                                
                                annotationView?.markerTintColor = UIColor(red: (247.0/255), green: (75.0/255), blue: (36.0/255), alpha: 1.0)

                            }
                        }
                    } else {
                        
                        annotationView?.markerTintColor = UIColor.gray
                        
                        }

                case .lpg:
                    if let price = stationData.lpgPrice {
                        
                        if let priceInt = Double(price.replacingOccurrences(of: ",", with: ".")) {
                            
                            if priceInt <= ResponseData.shared.average - 0.06 {
                                
                                annotationView?.markerTintColor = UIColor(red: (51.0/255), green: (161.0/255), blue: (79.0/255), alpha: 1.0)

                            } else if priceInt >= ResponseData.shared.average - 0.05 && priceInt <= ResponseData.shared.average + 0.05 {
                                
                                annotationView?.markerTintColor = UIColor(red: (249.0/255), green: (126.0/255), blue: (43.0/255), alpha: 1.0)

                            } else {
                                
                                annotationView?.markerTintColor = UIColor(red: (247.0/255), green: (75.0/255), blue: (36.0/255), alpha: 1.0)

                            }
                        }
                    } else {
                        
                        annotationView?.markerTintColor = UIColor.gray
                        
                        }

                case .cng:
                    if let price = stationData.cngPrice {
                        
                        if let priceInt = Double(price.replacingOccurrences(of: ",", with: ".")) {
                            
                            if priceInt <= ResponseData.shared.average - 0.06 {
                                
                                annotationView?.markerTintColor = UIColor(red: (51.0/255), green: (161.0/255), blue: (79.0/255), alpha: 1.0)

                            } else if priceInt >= ResponseData.shared.average - 0.05 && priceInt <= ResponseData.shared.average + 0.05 {
                                
                                annotationView?.markerTintColor = UIColor(red: (249.0/255), green: (126.0/255), blue: (43.0/255), alpha: 1.0)

                            } else {
                                
                                annotationView?.markerTintColor = UIColor(red: (247.0/255), green: (75.0/255), blue: (36.0/255), alpha: 1.0)

                            }
                        }
                    } else {
                        
                        annotationView?.markerTintColor = UIColor.gray
                        
                        }

                case .lng:
                    if let price = stationData.lngPrice {
                        
                        if let priceInt = Double(price.replacingOccurrences(of: ",", with: ".")) {
                            
                            if priceInt <= ResponseData.shared.average - 0.06 {
                                
                                annotationView?.markerTintColor = UIColor(red: (51.0/255), green: (161.0/255), blue: (79.0/255), alpha: 1.0)

                            } else if priceInt >= ResponseData.shared.average - 0.05 && priceInt <= ResponseData.shared.average + 0.05 {
                                
                                annotationView?.markerTintColor = UIColor(red: (249.0/255), green: (126.0/255), blue: (43.0/255), alpha: 1.0)

                            } else {
                                
                                annotationView?.markerTintColor = UIColor(red: (247.0/255), green: (75.0/255), blue: (36.0/255), alpha: 1.0)

                            }
                        }
                    } else {
                        
                        annotationView?.markerTintColor = UIColor.gray
                        
                        }

                }
            } else {
                
                annotationView?.markerTintColor = UIColor.gray
                }
            } else {
                
                annotationView?.markerTintColor = UIColor.gray
            }
        if annotation.title == "My Location" {
            print("user location found")
            annotationView = nil
        }

        return annotationView
    }

    @objc func dismissDetailSheet() {
        if let d = detailView {
            
            d.dismiss(animated: true, completion: nil)
        }
        
        self.selectedPin?.setSelected(false, animated: true)
        self.detailView = nil
    }
    
    func configureDetailSheet(vc: UIViewController, source: MKAnnotationView) {
        vc.modalPresentationStyle = .popover
        if let popover = vc.popoverPresentationController {
            popover.sourceView = source
            let sheet = popover.adaptiveSheetPresentationController
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.prefersGrabberVisible = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
    }
    
    func centerMapOnLocation(location: CLLocation, _ withZoom: Bool = false) {
        var coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: 2040, longitudinalMeters: 2040)
        
        if withZoom {
            
            coordinateRegion.span  = MKCoordinateSpan(latitudeDelta: 0.124, longitudeDelta: 0.011)
        }
      map.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func userPressedLocationButton() {
        
        self.centerMapOnLocation(location: (locationManager?.location)!)
    }
    
    func filterSelected() {
        self.activityIndicator.isHidden = false 
        self.activityIndicator.startAnimating()
    }

    @objc func filterAction() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapFilterView")
        (vc.children.first as! MapFilterViewController).delegate = self
        self.present(vc, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Constants.userLocation = manager
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse  || status == .authorizedAlways || status == .restricted {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                }
            }
        } else if status == .notDetermined {
            
        } else {
            NotificationCenter.default.post(name: NSNotification.Name("foundData"), object: nil)

        }
    }
}


