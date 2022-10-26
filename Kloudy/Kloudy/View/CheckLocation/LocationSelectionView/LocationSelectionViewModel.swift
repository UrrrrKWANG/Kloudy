//
//  LocationSelectionViewModel.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import CoreData

class LocationSelectionViewModel {
    var coreDataStack = CoreDataStack(modelName: "Location")
    
    func saveLocation(city: String, latitude: String, longtitude: String, sequence: Int) {
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        do {
            let locations = try coreDataStack.managedContext.fetch(request)
            let countLocations = locations.count
            
            let location = Location(context: coreDataStack.managedContext)
            location.city = city
            location.latitude = Double(latitude) ?? 0
            location.longitude = Double(longtitude) ?? 0
            location.sequence = Int16(countLocations)
            coreDataStack.saveContext()
        } catch {
            print("-----fetchLocationsError-----")
        }
    }
}
