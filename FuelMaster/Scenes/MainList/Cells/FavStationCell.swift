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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 320.0, height: 152.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let d = delegate {
            
            d.tapStation(data: (stationList?[indexPath.row])!)
        }
    }

}
