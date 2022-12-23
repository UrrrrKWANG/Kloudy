//
//  Storage.swift
//  Kloudy
//
//  Created by 이영준 on 2022/12/02.
//

import Foundation

public class Storage {
    static let defaultIndexArray = ["rain", "mask", "laundry", "car", "outer", "temperatureGap"]
    
    // 설치 후 첫 실행인지 확인
    class func isFirst() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "isFirst") == nil {
            Storage.saveCurrentLocationIndexArray(arrayString: Storage.defaultIndexArray)
            defaults.set("No", forKey: "isFirst")
            return true
        } else {
            return false
        }
    }
    
    class func isFirstBuild() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "isFirstBuild") == nil {
            defaults.set("No", forKey: "isFirstBuild")
            return true
        } else {
            return false
        }
    }
    
    // 현재 위치의 지수 순서를 UserDefaults 에 저장
    class func saveCurrentLocationIndexArray(arrayString: [String]) {
        do {
            try UserDefaults.standard.setObject(arrayString, forKey: "CurrentLocationIndexArray")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // UserDefaults 에 저장된 현재 위치의 지수 순서 Fetch
    class func fetchCurrentLocationIndexArray() -> [String] {
        var savedStrArray = [String]()
        do {
            try savedStrArray = UserDefaults.standard.getObject(forKey: "CurrentLocationIndexArray", castTo: [String].self)
        } catch {
            print(error.localizedDescription)
        }
        return savedStrArray
    }
    
    // UserDefaults 에 저장된 현재 위치의 지수 스트링의 IndexType 배열을 리턴
    class func convertStringToIndexType(indexStrArray: [String]) -> [IndexType] {
        var indexArray = [IndexType]()
        indexStrArray.forEach { index in
            switch index {
            case "rain":
                indexArray.append(.umbrella)
            case "mask":
                indexArray.append(.mask)
            case "laundry":
                indexArray.append(.laundry)
            case "car":
                indexArray.append(.car)
            case "outer":
                indexArray.append(.outer)
            case "temperatureGap":
                indexArray.append(.temperatureGap)
            default:
                break
            }
        }
        return indexArray
    }
}
