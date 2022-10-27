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
    
    func getWeather() -> [String]{
//        var asdf = weatherInformationModel.startLoad(province: "대전광역시", city: "중구")
//        sleep(2)
        print("-------------------------")
//        print(asdf)
//        print(type(of: asdf))
        let temp = ["서울","13","15","9","snowy"]
        return temp
    }
}

