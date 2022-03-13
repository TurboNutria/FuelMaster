//
//  APIManager.swift
//  FuelMaster
//
//  Created by Aura Silos on 4/11/21.
//

import Foundation

class APIManager {
    
    func getDataFromMinisty(result: @escaping( _ output: ResponseData?) -> Void) {

        if let url = URL(string: Constants.APIURl) {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                  do {
                     let res = try JSONDecoder().decode(ResponseData.self, from: data)
                      ResponseData.shared.stationList = res.stationList
                      result(res)
                  } catch let error {
                     print(error)
                  }
               }
           }.resume()
        }
    }
}
