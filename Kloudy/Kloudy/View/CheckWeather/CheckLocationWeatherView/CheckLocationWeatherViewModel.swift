//
//  CheckLocationWeatherViewModel.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import CoreData


class CheckLocationWeatherViewModel {
    let weatherInformationModel = FetchWeatherInformation()
    
    func hello() {
        var asdf = weatherInformationModel.startLoad(province: "대전광역시", city: "중구")
        print("-------------------------")
        print(asdf)
    }
    
}

