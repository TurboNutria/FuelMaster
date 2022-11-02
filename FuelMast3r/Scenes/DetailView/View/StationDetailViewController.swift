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
    func callToDeselect()
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
    
    override func viewDidDisappear(_ animated: Bool) {
        self.dismiss(animated: true, completion: nil)
        if let d = delegate {
            d.callToDeselect()
            d.dismissDetailSheet()
        }
    }
    
    func updateStation() {
        
        self.title = self.station?.owner!
        self.navigationController?.title = self.station?.owner!
        self.navigationItem.title = self.station?.owner!
         hasGas = false
         hasDiesel = false
         hasNaturalGas = false
         gasIsConfigured = false
         dieselIsConfigured = false
         naturalGasIsConfigured = false
         gasHeaderConfigured = false
         dieselHeaderConfigured = false
         naturalGasConfigured = false
        self.tableView.reloadData()
    }
    
    @IBAction func tapClose(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        if let d = delegate {
            d.callToDeselect()
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

            return cell
        } else if indexPath.section == tableView.numberOfSections - 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoDetailCell", for: indexPath) as! InfoDetailCell
            
            cell.hoursLabel.text = station?.openingHours!
            if let gasType = UserDefaults.standard.value(forKey: "gasType") as? String,
            let gasCase = GasType(rawValue: gasType) {
                switch gasCase {
                case .diesel:
                    if let stationSafe = station,
                       let stationPrice = stationSafe.regularDieselPrice?.replacingOccurrences(of: ",", with: "."),
                       let liters = UserDefaults.standard.value(forKey: "liters") as? Int
                        {

                       let x =  ((Double(stationPrice)!) * Double(liters))
                        let y = Double(round(1000 * x) / 1000)
                        cell.priceLabel.text = "\(y) €"
                    }
                case .gasoline:
                    if let stationSafe = station,
                       let stationPrice = stationSafe.regularGasPrice?.replacingOccurrences(of: ",", with: "."),
                       let liters = UserDefaults.standard.value(forKey: "liters") as? Int
                        {

                       let x =  ((Double(stationPrice)!) * Double(liters))
                        let y = Double(round(1000 * x) / 1000)
                        cell.priceLabel.text = "\(y) €"
                    }
                case .lpg:
                    if let stationSafe = station,
                       let stationPrice = stationSafe.lpgPrice?.replacingOccurrences(of: ",", with: "."),
                       let liters = UserDefaults.standard.value(forKey: "liters") as? Int
                        {

                       let x =  ((Double(stationPrice)!) * Double(liters))
                        let y = Double(round(1000 * x) / 1000)
                        cell.priceLabel.text = "\(y) €"
                    }
                case .cng:
                    if let stationSafe = station,
                       let stationPrice = stationSafe.cngPrice?.replacingOccurrences(of: ",", with: "."),
                       let liters = UserDefaults.standard.value(forKey: "liters") as? Int
                        {

                       let x =  ((Double(stationPrice)!) * Double(liters))
                        let y = Double(round(1000 * x) / 1000)
                        cell.priceLabel.text = "\(y) €"
                    }
                case .lng:
                    if let stationSafe = station,
                       let stationPrice = stationSafe.lngPrice?.replacingOccurrences(of: ",", with: "."),
                       let liters = UserDefaults.standard.value(forKey: "liters") as? Int
                        {

                       let x =  ((Double(stationPrice)!) * Double(liters))
                        let y = Double(round(1000 * x) / 1000)
                        cell.priceLabel.text = "\(y) €"
                    }
                }
            }
            
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
        if let gasType = UserDefaults.standard.value(forKey: "gasType") as? String,
        let gasCase = GasType(rawValue: gasType) {
            switch gasCase {
            case .diesel:
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
                    cell.updateLists()
                    dieselIsConfigured = true
                    return cell
                }

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
                    cell.updateLists()
                    gasIsConfigured = true
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
                    cell.updateLists()
                    naturalGasIsConfigured = true
                    return cell
                }

            case .gasoline:
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
                    cell.updateLists()
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
                    cell.updateLists()
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
                    cell.updateLists()
                    naturalGasIsConfigured = true
                    return cell
                }

            case .lpg, .cng, .lng:
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
                    cell.updateLists()
                    naturalGasIsConfigured = true
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
                    cell.updateLists()
                    dieselIsConfigured = true
                    return cell
                }

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
                    cell.updateLists()
                    gasIsConfigured = true
                    return cell
                }
            }
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
        if let gasType = UserDefaults.standard.value(forKey: "gasType") as? String,
        let gasCase = GasType(rawValue: gasType) {
            switch gasCase {
            case .diesel:
                if hasDiesel && !dieselHeaderConfigured {
                    
                    header.titleLabel.text = "Diésel"
                    header.sortButton.isHidden = true
                    dieselHeaderConfigured = true
                    return header
                }

                if hasGas && !gasHeaderConfigured {
                    
                    header.titleLabel.text = "Gasolina"
                    header.sortButton.isHidden = true
                    gasHeaderConfigured = true
                    return header
                }
                
                
                if hasNaturalGas && !naturalGasConfigured {
                    
                    header.titleLabel.text = "Gas"
                    header.sortButton.isHidden = true
                    naturalGasConfigured = true
                    return header
                }

            case .gasoline:
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

            case .cng, .lng, .lpg:
                if hasNaturalGas && !naturalGasConfigured {
                    
                    header.titleLabel.text = "Gas"
                    header.sortButton.isHidden = true
                    naturalGasConfigured = true
                    return header
                }

                if hasDiesel && !dieselHeaderConfigured {
                    
                    header.titleLabel.text = "Diésel"
                    header.sortButton.isHidden = true
                    dieselHeaderConfigured = true
                    return header
                }

                if hasGas && !gasHeaderConfigured {
                    
                    header.titleLabel.text = "Gasolina"
                    header.sortButton.isHidden = true
                    gasHeaderConfigured = true
                    return header
                }
                
                

            }
        }
        
        return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var sectionCount = 3
        
        if let s = station {
            if let gasType = UserDefaults.standard.value(forKey: "gasType") as? String,
            let gasCase = GasType(rawValue: gasType) {
                switch gasCase {
                case .diesel:
                    if !s.regularDieselPrice!.isEmpty || !s.premiumDieselPrice!.isEmpty || !s.bioDieselPrice!.isEmpty {
                        
                        sectionCount += 1
                        hasDiesel = true
                    }

                    if !s.superGasPrice!.isEmpty || !s.premiumGasPrice!.isEmpty || !s.regularGasPrice!.isEmpty || !s.bioEthanolPrice!.isEmpty {
                        
                        sectionCount += 1
                        hasGas = true
                    }
                    
                    
                    if !s.lpgPrice!.isEmpty || !s.lngPrice!.isEmpty || !s.cngPrice!.isEmpty {
                        
                        sectionCount += 1
                        hasNaturalGas = true
                    }

                case .gasoline:
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

                case .cng, .lng, .lpg:
                    if !s.lpgPrice!.isEmpty || !s.lngPrice!.isEmpty || !s.cngPrice!.isEmpty {
                        
                        sectionCount += 1
                        hasNaturalGas = true

                    if !s.superGasPrice!.isEmpty || !s.premiumGasPrice!.isEmpty || !s.regularGasPrice!.isEmpty || !s.bioEthanolPrice!.isEmpty {
                        
                        sectionCount += 1
                        hasGas = true
                    }
                    
                    if !s.regularDieselPrice!.isEmpty || !s.premiumDieselPrice!.isEmpty || !s.bioDieselPrice!.isEmpty {
                        
                        sectionCount += 1
                        hasDiesel = true
                    }
                    
                    }

                }
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
                
                var addedArray = UserDefaults.standard.array(forKey: "favList") as! [Int]
                addedArray.removeAll { element in
                    return element == Int((self.station?.IDEESS!)!)!
                }
                
                UserDefaults.standard.set(addedArray, forKey: "favList")
            } else {
                
                FavList.shared.stationList.append(self.station!)
                if UserDefaults.standard.array(forKey: "favList") != nil {
                    
                    var addedArray = UserDefaults.standard.array(forKey: "favList") as! [Int]
                    addedArray.append(Int((self.station?.IDEESS!)!)!)
                    UserDefaults.standard.set(addedArray, forKey: "favList")
                } else {
                    
                    let idArray: [Int] = [Int((self.station?.IDEESS!)!)!]
                    UserDefaults.standard.set(idArray, forKey: "favList")
                }
            }
        } else {
            
            FavList.shared.stationList.append(self.station!)
            if UserDefaults.standard.string(forKey: "favList") != nil {
                
                var addedArray = UserDefaults.standard.array(forKey: "favList") as! [Int]
                addedArray.append(Int((self.station?.IDEESS!)!)!)
                UserDefaults.standard.set(addedArray, forKey: "favList")
            } else {
                
                let idArray: [Int] = [Int((self.station?.IDEESS!)!)!]
                UserDefaults.standard.set(idArray, forKey: "favList")
            }
        }
    }
    
    func tapShare() {
        
        let stationDirection = station?.address?.replacingOccurrences(of: " ", with: "+")
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [ NSURL(string: "http://maps.apple.com/?q=\(stationDirection!)")!], applicationActivities: nil)

        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = self.tableView


        // Anything you want to exclude

        self.present(activityViewController, animated: true, completion: nil)

    }
}
