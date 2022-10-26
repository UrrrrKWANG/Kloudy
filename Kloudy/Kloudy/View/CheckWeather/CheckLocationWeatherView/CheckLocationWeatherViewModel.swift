//
//  CheckLocationWeatherViewModel.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import Foundation
import UIKit
import CoreData


class CheckLocationWeatherViewModel {
    let weatherInformationModel = FetchWeatherInformation()
    
    func hello() {
        var asdf = weatherInformationModel.startLoad(city: "종로구")
        print("-------------------------")
        print(asdf)
    }
    
}

