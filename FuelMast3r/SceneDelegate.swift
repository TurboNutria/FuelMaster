//
//  SceneDelegate.swift
//  FuelMaster
//
//  Created by Aura Silos on 4/11/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        UserDefaults.standard.set(nil, forKey: "backgroundDate")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        if UserDefaults.standard.value(forKey: "gasType") as? String == nil {
        }
        
        
        if let originalDate = UserDefaults.standard.value(forKey: "backgroundDate") as? Date {
            
            let currentDate = Date()
            if DateInterval(start: originalDate, end: currentDate).duration >= Constants.OneDay {
                
                NotificationCenter.default.post(name: NSNotification.Name("refresh"), object: nil)
                APIManager().getDataFromMinisty { output in
                    UserDefaults.standard.set(Date(), forKey: "fecha")
                    UserDefaults.standard.set(false, forKey: "regional")
                    var priceArray: [Double] = []
                
                    for element in ResponseData.shared.stationList {
                        
                        if let price = element.regularGasPrice,
                           let priceDouble = Double(price.replacingOccurrences(of: ",", with: ".")),
                           let province = element.province {
                            
                            if !province.uppercased().contains("TENERIFE") || !province.uppercased().contains("PALMAS") || !province.uppercased().contains("CEUTA") || !province.uppercased().contains("MELILLA") {

                                priceArray.append(priceDouble)
                            }
                        }
                    }
                    
                    let average = priceArray.reduce(0.0) {
                        return $0 + $1/Double(priceArray.count)
                    }
                    
                    let modList = ResponseData.shared.stationList.filter { element in
                        
                        if element.regularGasPrice != "" {
                            
                            if let priceDouble = Double(element.regularGasPrice!.replacingOccurrences(of: ",", with: ".")) {
                                
                                if priceDouble <= average - 0.06 {
                                    
                                    return true
                                } else {
                                    
                                    return false
                                }
                            } else {
                                
                                return false
                            }
                        } else {
                            
                            return false
                        }
                    }
                    
                    ResponseData.shared.average = average
                    ResponseData.shared.regularList = ResponseData.shared.stationList
                    ResponseData.shared.stationList.removeAll()
                    ResponseData.shared.stationList = modList
                    UserDefaults.standard.setValue(Date(), forKey: "backgroundDate")
                    NotificationCenter.default.post(name: NSNotification.Name("foundData"), object: nil)
                }
            } else {
                
                NotificationCenter.default.post(name: NSNotification.Name("refresh"), object: nil)
            }
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        UserDefaults.standard.set(Date(), forKey: "backgroundDate")
    }


}

