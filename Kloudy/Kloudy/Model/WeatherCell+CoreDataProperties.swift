//
//  WeatherCell+CoreDataProperties.swift
//  Kloudy
//
//  Created by Geunil Park on 2022/10/17.
//
//

import Foundation
import CoreData


extension WeatherCell {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherCell> {
        return NSFetchRequest<WeatherCell>(entityName: "WeatherCell")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var size: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var type: String?
    @NSManaged public var location: Location?
    
}

extension WeatherCell : Identifiable {

}
