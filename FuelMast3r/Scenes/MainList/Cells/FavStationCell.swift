//
//  FavStationCell.swift
//  FuelMaster
//
//  Created by Aura Silos on 7/11/21.
//

import UIKit
import CoreLocation

protocol FavListDelegate: AnyObject {
    func tapStation(data: StationData)
    func presentShareSheet(vc: UIActivityViewController)
    func updateList()
}


class FavStationCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var stationList: [StationData]?
    weak var delegate: FavListDelegate?
    var locationManager: CLLocationManager?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "StationCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "StationCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let list = stationList {
            
            if list.isEmpty {
                
                self.collectionView.isHidden = true
                self.emptyLabel.isHidden = false
            } else {
                
                self.collectionView.isHidden = false
                self.emptyLabel.isHidden = true
            }

                self.collectionView.reloadData()
        }
    }
    
    func reloadCollection() {
        
        
        if let list = stationList {
            
            if list.isEmpty {
                
                self.collectionView.isHidden = true
                self.emptyLabel.isHidden = false
            } else {
                
                self.collectionView.isHidden = false
                self.emptyLabel.isHidden = true
            }

                self.collectionView.reloadData()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stationList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StationCollectionCell", for: indexPath) as! StationCollectionCell
                
        if let list = stationList {
            
            let distance = CLLocation.distance(from: (locationManager?.location!.coordinate)! , to: CLLocationCoordinate2D(latitude: list[indexPath.row].latitudeDouble, longitude: list[indexPath.row].longitudeDouble))
            let roundedValue = round((distance / 1000) * 100) / 100.0

            cell.distanceLabel.text = String(roundedValue).replacingOccurrences(of: ".", with: ",") + " km"
            cell.stationName.text = list[indexPath.row].owner!
            cell.stationName.text = list[indexPath.row].owner!
            if let ownerName = list[indexPath.row].owner {
                
                let ownerString = Constants.ownersList.filter { owner in
                    return ownerName.contains(owner)
                }
                if ownerString.count > 0 {
                    
                    if let image = UIImage(named: ownerString.first!) {
                        
                        cell.ownerImage.image = image
                    } else {
                        
                        cell.ownerImage.image = UIImage(systemName: "fuelpump.circle")
                    }
                } else {
                    
                    cell.ownerImage.image = UIImage(systemName: "fuelpump.circle")
                }
            } else {
                
                cell.ownerImage.image = UIImage(systemName: "fuelpump.circle")
            }

            if let gasType = UserDefaults.standard.value(forKey: "gasType") as? String,
            let gasCase = GasType(rawValue: gasType) {
                switch gasCase {
                case .diesel:
                    if let regGasPrice = list[indexPath.row].regularDieselPrice {
                        
                        if regGasPrice == "" {
                            
                            cell.regularGasLabel.text = "Diésel    -,---€"
                        } else {
                            
                            cell.regularGasLabel.text = "Diésel    " +  regGasPrice + "€"
                        }
                    }
                    
                    if let plusGasPrice = list[indexPath.row].premiumDieselPrice {
                        
                        if plusGasPrice == "" {
                            
                            cell.superGasLabel.text = "Diésel Premium    -,---€"
                        } else {
                            
                            cell.superGasLabel.text = "Diésel Premium    " + plusGasPrice + "€"
                        }
                    }

                case .gasoline:
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
                case .lpg:
                    if let regGasPrice = list[indexPath.row].lpgPrice {
                        
                        if regGasPrice == "" {
                            
                            cell.regularGasLabel.text = "GLP    -,---€"
                        } else {
                            
                            cell.regularGasLabel.text = "GLP    " +  regGasPrice + "€"
                        }
                    }
                    
                    cell.superGasLabel.text = ""

                case .cng:
                    if let regGasPrice = list[indexPath.row].cngPrice {
                        
                        if regGasPrice == "" {
                            
                            cell.regularGasLabel.text = "GNC    -,---€"
                        } else {
                            
                            cell.regularGasLabel.text = "GNC    " +  regGasPrice + "€"
                        }
                    }
                    
                    cell.superGasLabel.text = ""

                case .lng:
                    if let regGasPrice = list[indexPath.row].lngPrice {
                        
                        if regGasPrice == "" {
                            
                            cell.regularGasLabel.text = "GNL    -,---€"
                        } else {
                            
                            cell.regularGasLabel.text = "GNL    " +  regGasPrice + "€"
                        }
                    }
                    
                    cell.superGasLabel.text = ""
                }
            }        }
        
        cell.regularGasPrice.text = ""
        cell.superGasPrice.text = ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        // 1
        let index = indexPath.row
        let station = self.stationList![indexPath.row]
        // 2
        let identifier = "\(index)" as NSString
        
        return UIContextMenuConfiguration(
          identifier: identifier,
          previewProvider: nil) { _ in
            // 3
              let mapAction: UIAction?
              if !FavList.shared.stationList.isEmpty {
                   
                  if FavList.shared.stationList.contains(where: { data in
                      data.address == station.address
                  }) {
                      
                      mapAction = UIAction(
                        title: "Quitar de favoritos",
                        image: UIImage(systemName: "star.slash"), attributes: .destructive) { _ in
                            FavList.shared.stationList.removeAll { data in
                                data.address == station.address
                            }
                            
                            var addedArray = UserDefaults.standard.array(forKey: "favList") as! [Int]
                            addedArray.removeAll { element in
                                return element == Int((station.IDEESS!))!
                            }
                            
                            UserDefaults.standard.set(addedArray, forKey: "favList")
                            self.delegate?.updateList()
                        }

                  } else {
                      
                       mapAction = UIAction(
                        title: "Añadir a favoritos",
                        image: UIImage(systemName: "star")) { _ in
                            FavList.shared.stationList.append(station)
                            if UserDefaults.standard.array(forKey: "favList") != nil {
                                
                                var addedArray = UserDefaults.standard.array(forKey: "favList") as! [Int]
                                addedArray.append(Int((station.IDEESS!))!)
                                UserDefaults.standard.set(addedArray, forKey: "favList")
                            } else {
                                
                                let idArray: [Int] = [Int((station.IDEESS!))!]
                                UserDefaults.standard.set(idArray, forKey: "favList")
                            }
                            self.delegate?.updateList()
                      }
                  }} else {
                      
                       mapAction = UIAction(
                        title: "Añadir a favoritos",
                        image: UIImage(systemName: "star")) { _ in
                            FavList.shared.stationList.append(station)
                            if UserDefaults.standard.array(forKey: "favList") != nil {
                                
                                var addedArray = UserDefaults.standard.array(forKey: "favList") as! [Int]
                                addedArray.append(Int((station.IDEESS!))!)
                                UserDefaults.standard.set(addedArray, forKey: "favList")
                            } else {
                                
                                let idArray: [Int] = [Int((station.IDEESS!))!]
                                UserDefaults.standard.set(idArray, forKey: "favList")
                            }
                            self.delegate?.updateList()
                      }
                  }

            // 4
            let shareAction = UIAction(
              title: "Compartir",
              image: UIImage(systemName: "square.and.arrow.up")) { _ in
                  let stationDirection = station.address?.replacingOccurrences(of: " ", with: "+")
                  let stationDirectionSaned = stationDirection?.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "Ñ", with: "N")
                  let activityViewController : UIActivityViewController = UIActivityViewController(
                      activityItems: [ NSURL(string: "http://maps.apple.com/?q=\(stationDirectionSaned!)")!], applicationActivities: nil)

                  // This lines is for the popover you need to show in iPad
                  activityViewController.popoverPresentationController?.sourceView = self.collectionView


                  // Anything you want to exclude

                  self.delegate?.presentShareSheet(vc: activityViewController)
              }
            
            // 5
            return UIMenu(title: "", image: nil, children: [mapAction!, shareAction])
        }
      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 320.0, height: 182.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let d = delegate {
            
            d.tapStation(data: (stationList?[indexPath.row])!)
        }
    }

}
