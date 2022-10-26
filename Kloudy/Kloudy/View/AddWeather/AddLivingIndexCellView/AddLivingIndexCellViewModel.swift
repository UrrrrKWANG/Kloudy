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
    
    func fetchLocationCells(cityName: String) -> Set<WeatherCell> {
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        let predicate = NSPredicate(
            format: "city = %@", "\(cityName)"
        )
        var cellSet = Set<WeatherCell>()
        
        do {
            request.predicate = predicate
            let location = try coreDataStack.managedContext.fetch(request).first
            location!.weatherCellArray.forEach { cell in
                cellSet.insert(cell)
            }
            return cellSet
        } catch {
            print("-----fetchLocationCellError-----")
            return Set()
        }
    }
    
}
