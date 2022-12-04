//
//  UserDefaults+.swift
//  Kloudy
//
//  Created by 이영준 on 2022/12/03.
//

import Foundation

// UserDefaults 에 [String] 타입의 데이터를 저장하기 위해서는 따로 아카이빙/언아카이빙 작업이 필요
extension UserDefaults: ObjectStorage {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectStorageError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectStorageError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectStorageError.unableToDecode
        }
    }
}
