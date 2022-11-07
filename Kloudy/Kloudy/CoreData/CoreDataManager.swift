//
//  CoreDataManager.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/07.
//

import UIKit
import CoreData

class CoreDataManager {
    // 사용 방법: CoreDataManager.shared.countLocations()
    static let shared: CoreDataManager = CoreDataManager()
    
    var coreDataStack = CoreDataStack(modelName: "Kloudy")
    
    func fetchLocations() -> [Location] {
        let request = NSFetchRequest<Location>(entityName: "Location")
        do {
            let locations = try coreDataStack.managedContext.fetch(request)
            return locations
        } catch {
            print("-----fetchLocationsError-----")
            return []
        }
    }
    
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
                    return
                }
            }
            return returnValue
        } catch {
            print("-----SameLocationsError-----")
            return true
        }
    }
    
    func saveWeatherCell(location: NSManagedObject, cells: [WeatherCell]) {
        for cell in cells {
            let cellObject = NSEntityDescription.insertNewObject(forEntityName: "WeatherCell", into: coreDataStack.managedContext) as! WeatherCell
            cellObject.type = cell.type
            cellObject.size = cell.size
            cellObject.latitude = cell.latitude
            cellObject.longitude = cell.longitude
            
            (location as! Location).addToWeatherCell(cellObject)
        }
    }
    // 지역을 삭제
    func locationDelete(location: NSManagedObject) {
        coreDataStack.managedContext.delete(location)

        coreDataStack.saveContext()
    }
}
