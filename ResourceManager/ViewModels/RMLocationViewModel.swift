//
//  RMLocationViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/12.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift
import MapKit

protocol RMLocationAction: RMViewModelAction {
    func reload()
}

class RMLocationViewModel: RMViewModel, RMListDataSource {
    var datasource: Array<RMSection<MKMapItem, Void>> = []
    var locationManager = LocationManager.sharedInstance
    weak var action: RMLocationAction?
    var query = Variable("")
    
     init(action:  RMLocationAction) {
        self.datasource.append(RMSection())
        self.action = action
        locationManager.autoUpdate = true
    }
    
    
    func start (query: String = "supermarket,village,Community，Shop,Restaurant，School，hospital，Company，Street，Convenience store，Shopping Centre，Place names，Hotel，Grocery store")  {
        
        locationManager.startUpdatingLocationWithCompletionHandler {[weak self] (latitude, longitude, status, verboseMessage, error) in
            if let strongSelf = self {
                strongSelf.action?.animation.value = true
                let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                strongSelf.locationManager.search(query: query, coordinate: coordinate, region: 1000, completionHandler: { (response, error) in
                    strongSelf.datasource.removeAll()
                    strongSelf.action?.animation.value = false
                    let section = RMSection<MKMapItem, Void>()
                    if let mapItems = response?.mapItems {
                        section.append(contentsOf: mapItems)
                        strongSelf.datasource.append(section)
                        strongSelf.action?.reload()
                    }
                })
            }
        }
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
    
    
}
