//
//  StationDetailViewController.swift
//  FuelMaster
//
//  Created by Aura Silos on 5/11/21.
//

import Foundation
import UIKit
import MapKit

protocol StationDetialDelegate: AnyObject {
    func dismissDetailSheet()
}

class StationDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DetailHeaderProtocol {
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: StationDetialDelegate?
    var titleLabel: String = ""
    var station: StationData?
    var hasGas = false
    var hasDiesel = false
    var hasNaturalGas = false
    var gasIsConfigured = false
    var dieselIsConfigured = false
    var naturalGasIsConfigured = false
    var gasHeaderConfigured = false
    var dieselHeaderConfigured = false
    var naturalGasConfigured = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateStation()
        tableView.delegate = self
        tableView.dataSource = self
        let headerNib = UINib(nibName: "DetailHeaderCell", bundle: nil)
        tableView.register(headerNib, forCellReuseIdentifier: "DetailHeaderCell")
        let priceNib = UINib(nibName: "PriceContainerCell", bundle: nil)
        tableView.register(priceNib, forCellReuseIdentifier: "PriceContainerCell")
        let infoCell = UINib(nibName: "InfoDetailCell", bundle: nil)
        tableView.register(infoCell, forCellReuseIdentifier: "InfoDetailCell")
        let footerCell = UINib(nibName: "DetailFooterCell", bundle: nil)
        tableView.register(footerCell, forCellReuseIdentifier: "DetailFooterCell")
        let titleHeaderNib = UINib(nibName: "ListHeaderView", bundle: nil)
        tableView.register(titleHeaderNib, forHeaderFooterViewReuseIdentifier: "ListHeaderView")
    }
    
    func updateStation() {
        
        self.title = self.station?.owner!
        self.navigationController?.title = self.station?.owner!
        self.navigationItem.title = self.station?.owner!
    }
    
    @IBAction func tapClose(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        if let d = delegate {
            
            d.dismissDetailSheet()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailHeaderCell", for: indexPath) as! DetailHeaderCell
            
            cell.delegate = self
            cell.addressLabel.text = station?.address!
            cell.subAddressLabel.text =  (station?.city!)!
            if let stationOwner = station,
               let ownerName = stationOwner.owner {
                
                if ownerName.uppercased().contains("BALLENOIL") {
                    
                    cell.ownerImage.image = UIImage(named: "ballenoil")
                }
            }
            
            return cell
        } else if indexPath.section == tableView.numberOfSections - 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoDetailCell", for: indexPath) as! InfoDetailCell
            
            cell.hoursLabel.text = station?.openingHours!
            
            return cell
        } else if indexPath.section == tableView.numberOfSections - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailFooterCell", for: indexPath) as! DetailFooterCell
            cell.delegate = self
            if !FavList.shared.stationList.isEmpty {
                 
                if FavList.shared.stationList.contains(where: { data in
                    data.address == self.station?.address
                }) {
                    
                    cell.isAlreadyFav = true
                    cell.favButton.setTitle("Quitar de favoritos", for: .normal)
                } else {
                    
                    cell.isAlreadyFav = false
                    cell.favButton.setTitle("Añadir a favoritos", for: .normal)
                }} else {
                    
                    cell.isAlreadyFav = false
                    cell.favButton.setTitle("Añadir a favoritos", for: .normal)
                }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PriceContainerCell", for: indexPath) as! PriceContainerCell
            return configurePriceCell(cell: cell)
        }
    }
    
    func configurePriceCell(cell: PriceContainerCell) -> PriceContainerCell {
        if hasGas && !gasIsConfigured {
            
            var pricelist: [PriceModel] = []
            
            if station?.regularGasPrice != "" {
                
                pricelist.append(PriceModel(price: station?.regularGasPrice, name: "95"))
            }
            
            if station?.superGasPrice != "" {
                
                pricelist.append(PriceModel(price: station?.superGasPrice, name: "98"))
            }

            if station?.premiumGasPrice != "" {
                
                pricelist.append(PriceModel(price: station?.premiumGasPrice, name: "95+"))
            }

            if station?.bioEthanolPrice != "" {
                
                pricelist.append(PriceModel(price: station?.bioEthanolPrice, name: "Bio"))
            }
            
            cell.pricesList = pricelist
            gasIsConfigured = true
            return cell
        }
        
        if hasDiesel && !dieselIsConfigured {
            
            var pricelist: [PriceModel] = []
            
            if station?.regularDieselPrice != "" {
                
                pricelist.append(PriceModel(price: station?.regularDieselPrice, name: "Normal"))
            }
            
            if station?.premiumDieselPrice != "" {
                
                pricelist.append(PriceModel(price: station?.premiumDieselPrice, name: "Premium"))
            }

            if station?.bioDieselPrice != "" {
                
                pricelist.append(PriceModel(price: station?.bioDieselPrice, name: "Bio"))
            }

            cell.pricesList = pricelist
            dieselIsConfigured = true
            return cell
        }
        
        if hasNaturalGas && !naturalGasIsConfigured {
            
            var pricelist: [PriceModel] = []
            
            if station?.cngPrice != "" {
                
                pricelist.append(PriceModel(price: station?.cngPrice, name: "GNC"))
            }
            
            if station?.lpgPrice != "" {
                
                pricelist.append(PriceModel(price: station?.lpgPrice, name: "GLP"))
            }

            if station?.lngPrice != "" {
                
                pricelist.append(PriceModel(price: station?.lngPrice, name: "GNL"))
            }

            cell.pricesList = pricelist
            naturalGasIsConfigured = true
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            
            return 130
        } else if indexPath.section == tableView.numberOfSections - 1 {
            
            return 250
        } else if indexPath.section == tableView.numberOfSections - 2 {
            
            return 130
        } else {
            
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            
            return 0
        } else if section == tableView.numberOfSections - 1 {
            
            return 0
        } else {
            
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ListHeaderView") as! ListHeaderView
        
        if section == 0 {
            
            return nil
        } else if section == tableView.numberOfSections - 2 {
        
            header.titleLabel.text = "Información"
            header.sortButton.isHidden = true
            return header
        } else if section == tableView.numberOfSections - 1 {
            
            return nil
        } else {
         
            return configureHeader(header: header)
        }
    }
    
    func configureHeader(header: ListHeaderView) -> ListHeaderView {
        if hasGas && !gasHeaderConfigured {
            
            header.titleLabel.text = "Gasolina"
            header.sortButton.isHidden = true
            gasHeaderConfigured = true
            return header
        }
        
        if hasDiesel && !dieselHeaderConfigured {
            
            header.titleLabel.text = "Diésel"
            header.sortButton.isHidden = true
            dieselHeaderConfigured = true
            return header
        }
        
        if hasNaturalGas && !naturalGasConfigured {
            
            header.titleLabel.text = "Gas"
            header.sortButton.isHidden = true
            naturalGasConfigured = true
            return header
        }
        
        return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var sectionCount = 3
        
        if let s = station {
            if !s.superGasPrice!.isEmpty || !s.premiumGasPrice!.isEmpty || !s.regularGasPrice!.isEmpty || !s.bioEthanolPrice!.isEmpty {
                
                sectionCount += 1
                hasGas = true
            }
            
            if !s.regularDieselPrice!.isEmpty || !s.premiumDieselPrice!.isEmpty || !s.bioDieselPrice!.isEmpty {
                
                sectionCount += 1
                hasDiesel = true
            }
            
            if !s.lpgPrice!.isEmpty || !s.lngPrice!.isEmpty || !s.cngPrice!.isEmpty {
                
                sectionCount += 1
                hasNaturalGas = true
            }
        }
        
        return sectionCount
    }
    
    func tapNavigate() {
        let lon = Double((station?.longitude?.replacingOccurrences(of: ",", with: "."))!)!
        let lat = Double((station?.latitude.replacingOccurrences(of: ",", with: "."))!)!
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = station?.owner!
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
}

extension StationDetailViewController: detailFooterDelegate {
    func tapFav() {
        if !FavList.shared.stationList.isEmpty {
            
            if FavList.shared.stationList.contains(where: { data in
                data.address == self.station?.address
            }) {
                
                FavList.shared.stationList.removeAll { data in
                    data.address == self.station?.address
                }
                
            } else {
                
                FavList.shared.stationList.append(self.station!)
            }
        } else {
            
            FavList.shared.stationList.append(self.station!)
        }
    }
    
    func tapShare() {
        let lon = Double((station?.longitude?.replacingOccurrences(of: ",", with: "."))!)!
        let lat = Double((station?.latitude.replacingOccurrences(of: ",", with: "."))!)!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [ NSURL(string: "https://maps.apple.com/?ll\(lat),\(lon)&q=Chincheta")!], applicationActivities: nil)

        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = self.tableView


        // Anything you want to exclude

        self.present(activityViewController, animated: true, completion: nil)

    }
}
