//
//  AddLivingIndexCellViewModel.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import CoreData

class AddLivingIndexCellViewModel {
    var coreDataStack = CoreDataStack(modelName: "Kloudy")
    
    func fetchLocationCells(cityCode: String) -> Set<WeatherCell> {
        let request = NSFetchRequest<Location>(entityName: "Location")
        do {
            let locations = try coreDataStack.managedContext.fetch(request)
            var findingLocation = Location()
            locations.forEach { location in
                if location.city == cityCode {
                    findingLocation = location
                }
            }
            return findingLocation.weatherCellArray
        } catch {
            print("-----fetchLocationCellError-----")
            return Set()
        }
    }
}
