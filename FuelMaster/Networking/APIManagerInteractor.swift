//
//  APIManagerInteractor.swift
//  FuelMaster
//
//  Created by Aura Silos on 4/11/21.
//

import Foundation

protocol APIManagerOutput: AnyObject {
    func foundData(data: ResponseData?)
}

class APIManagerInteractor {
    
    weak var presenter: APIManagerOutput?
    var repository: APIManager = APIManager()
    
    func getDataFromMinistry() {
        self.repository.getDataFromMinisty { output in
            self.presenter?.foundData(data: output)
        }
    }
    
    func sortData() {
        self.repository.changeMainList()
    }
}
