//
//  Location+CoreDataProperties.swift
//  Kloudy
//
//  Created by Geunil Park on 2022/10/17.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var province: String?
    @NSManaged public var city: String?
    
    public var weatherCellArray: Set<WeatherCell> {
        let set = weatherCell as? Set<WeatherCell> ?? []
        return set
    }
}

// MARK: Generated accessors for weatherCell
extension Location {

    @objc(addWeatherCellObject:)
    @NSManaged public func addToWeatherCell(_ value: WeatherCell)

    @objc(removeWeatherCellObject:)
    @NSManaged public func removeFromWeatherCell(_ value: WeatherCell)

    @objc(addWeatherCell:)
    @NSManaged public func addToWeatherCell(_ values: NSSet)

    @objc(removeWeatherCell:)
    @NSManaged public func removeFromWeatherCell(_ values: NSSet)

}

extension Location : Identifiable {

}
