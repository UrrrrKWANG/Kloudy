//
//  LocationSelectionViewModel.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import CoreData

class LocationSelectionViewModel {
    var coreDataStack = CoreDataStack(modelName: "Kloudy")
    
    func saveLocation(city: String, latitude: Double, longtitude: Double, sequence: Int) {
        let request = NSFetchRequest<Location>(entityName: "Location")
        do {
            let locations = try coreDataStack.managedContext.fetch(request)
            let countLocations = locations.count
            let location = NSEntityDescription.insertNewObject(forEntityName: "Location", into: coreDataStack.managedContext)
            location.setValue(city, forKey: "city")
            location.setValue(latitude, forKey: "latitude")
            location.setValue(longtitude, forKey: "longtitude")
            location.setValue(countLocations, forKey: "sequence")
            coreDataStack.saveContext()
        } catch {
            print("-----fetchLocationsError-----")
        }
    }
    
    func countLocations() -> Int {
        let request = NSFetchRequest<Location>(entityName: "Location")
        do {
            let locations = try coreDataStack.managedContext.fetch(request)
            return locations.count
        } catch {
            print("-----CountLocationError-----")
            return 0
        }
    }
    
    func checkLocationIsSame(locationCode: String) -> Bool {
        let request = NSFetchRequest<Location>(entityName: "Location")
        do {
            let locations = try coreDataStack.managedContext.fetch(request)
            var returnValue = true
            locations.forEach { location in
                if location.city == locationCode {
                    returnValue = false
                }
            }
            return returnValue
        } catch {
            print("-----SameLocationsError-----")
            return true
        }
    }
}
