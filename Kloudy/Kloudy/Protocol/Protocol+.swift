//
//  Protocol+.swift
//  Kloudy
//
//  Created by 이주화 on 2022/10/28.
//

import Foundation

protocol collectionViewCelDeleteButtonlClicked {
    func buttonClicked(indexPath: Int)
}

protocol LocationSelectionDelegate: AnyObject {
    func sendWeatherData(weatherData: [Weather])
}

protocol ObjectStorage {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

enum ObjectStorageError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    var errorDescription: String? {
        rawValue
    }
}
