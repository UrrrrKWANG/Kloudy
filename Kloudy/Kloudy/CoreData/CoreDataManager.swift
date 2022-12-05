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
    
    func saveLocation(code: String, city: String, province: String, sequence: Int, indexArray: [String]) {
        let request = NSFetchRequest<Location>(entityName: "Location")
        do {
            let locations = try coreDataStack.managedContext.fetch(request)
            let location = NSEntityDescription.insertNewObject(forEntityName: "Location", into: coreDataStack.managedContext)
            location.setValue(code, forKey: "code")
            location.setValue(city, forKey: "city")
            location.setValue(province, forKey: "province")
            location.setValue(indexArray, forKey: "indexArray")
            coreDataStack.saveContext()
        } catch {
            print("-----fetchLocationsError-----")
        }
    }
    
    func changeLocationIndexData(code: String, indexArray: [String]) {
        //https://stackoverflow.com/questions/26345189/how-do-you-update-a-coredata-entry-that-has-already-been-saved-in-swift
        let request = NSFetchRequest<Location>(entityName: "Location")
        do {
            let currentLoctaion: Location!
            request.predicate = NSPredicate(format: "code = %@", code as String)
            let results = try coreDataStack.managedContext.fetch(request)
            if results.count == 0 {
                currentLoctaion = Location(context: coreDataStack.managedContext)
            } else {
                currentLoctaion = results.first
            }
            currentLoctaion.indexArray = indexArray
            coreDataStack.saveContext()
        } catch {
            print(error)
        }
    }
    
    // https://github.com/PLREQ/PLREQ
    func getLocationSequence(locationList: [LocationData]) {
        let request = NSFetchRequest<Location>(entityName: "Location")
        do {
            let locations = try coreDataStack.managedContext.fetch(request)
            for i in 0..<locations.count {
                locations[i].setValue(locationList[i].code, forKey: "code")
                locations[i].setValue(locationList[i].city, forKey: "city")
                locations[i].setValue(locationList[i].province, forKey: "province")
            }
            coreDataStack.saveContext()
        } catch {
            print("------getLocationSequenceError------")
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
    
    func deleteLocation(location: Location){
        let request = NSFetchRequest<Location>(entityName: "Location")
        do {
            var locations = try coreDataStack.managedContext.fetch(request)
            for locationIndex in locations.indices {
                if locations[locationIndex].code == location.code {
                    self.coreDataStack.managedContext.delete(location)
                    break
                }
            }
        } catch {
            print("-----SameLocationsError-----")
        }
        coreDataStack.saveContext()
    }
    
    func convertStringToIndexTypeArray(indexStrArray: [String]) -> [IndexType] {
        var indexTypeArray = [IndexType]()
        indexStrArray.forEach { index in
            switch index {
            case "rain":
                indexTypeArray.append(.umbrella)
            case "mask":
                indexTypeArray.append(.mask)
            case "laundry":
                indexTypeArray.append(.laundry)
            case "car":
                indexTypeArray.append(.car)
            case "outer":
                indexTypeArray.append(.outer)
            case "temperatureGap":
                indexTypeArray.append(.temperatureGap)
            default:
                break
            }
        }
        return indexTypeArray
    }
}
