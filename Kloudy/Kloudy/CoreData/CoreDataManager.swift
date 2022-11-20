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
    
    func saveLocation(code: String, city: String, province: String, sequence: Int ,indexArray: [String]) {
        let request = NSFetchRequest<Location>(entityName: "Location")
        do {
            let locations = try coreDataStack.managedContext.fetch(request)
            let countLocations = locations.count
            let location = NSEntityDescription.insertNewObject(forEntityName: "Location", into: coreDataStack.managedContext)
            location.setValue(code, forKey: "code")
            location.setValue(city, forKey: "city")
            location.setValue(province, forKey: "province")
            location.setValue(countLocations, forKey: "sequence")
            location.setValue(indexArray, forKey: "indexArray")
            print(indexArray , "indexArray")
            coreDataStack.saveContext()
        } catch {
            print("-----fetchLocationsError-----")
        }
    }
    
    func changeLocationIndexData(code: String, indexArray: [String]) {
        //https://stackoverflow.com/questions/26345189/how-do-you-update-a-coredata-entry-that-has-already-been-saved-in-swift
        do {
            var context: NSManagedObjectContext {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                return appDelegate.persistentContainer.viewContext
            }
            let currentLoctaion: Location!
            let fetchLocation: NSFetchRequest<Location> = Location.fetchRequest()
            fetchLocation.predicate = NSPredicate(format: "code = %@", code as String)
            let results = try? context.fetch(fetchLocation)
            if results?.count == 0 {
                currentLoctaion = Location(context: context)
            } else {
                currentLoctaion = results?.first
            }
            currentLoctaion.indexArray = indexArray
            try context.save()
        } catch {
            print(error)
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
                if location.code == locationCode {
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
