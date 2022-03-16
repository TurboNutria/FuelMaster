//
//  SplitViewControllerManager.swift
//  FuelMaster
//
//  Created by Aura Silos on 4/11/21.
//

import Foundation
import UIKit
import CoreLocation

class SplitViewControllerManager: UISplitViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    var data: [StationData]?
    var mapView: MapViewController?
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
//        let mainList = ((self.viewControllers.first as! UINavigationController).viewControllers.first as! MainListViewController)
//        mainList.mapView = ((self.viewControllers.last as! UINavigationController).viewControllers.first as! MapViewController)
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
            
        }
    }
}

extension CLLocation {
    
    /// Get distance between two points
    ///
    /// - Parameters:
    ///   - from: first point
    ///   - to: second point
    /// - Returns: the distance in meters
    class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}
