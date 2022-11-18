//
//  FetchWeatherInformation.swift
//  Kloudy
//
//  Created by Geunil Park on 2022/10/18.
//

import Foundation

class FetchWeatherInformation: ObservableObject {
    
    func getCityInformaiton(province:String, city: String) -> String {
        let koreanCities: [CityInformation] = loadCityListFromCSV()
        
        let nowCity = koreanCities.filter{ $0.province == province && $0.city == city }[0]
        
        return String(nowCity.code)
    }
    
    func getNowTimeForQuery() -> [String] {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd HH mm"
        let tempString = dateFormatter.string(from: nowDate).split(separator: " ")
        
        var day = String(tempString[0])
        let time = calculateTime(timeStrings: tempString.map{ String($0) })
        
        if time == "2330" {
            day = String(Int(day)! - 1)
        }
        
        return [day, time]
    }
    
    func calculateTime(timeStrings: [String]) -> String {
        var hour = timeStrings[1]
        let minute = timeStrings[2]
        
        if hour == "00" {
            var tempMinute = Int(minute)!
            if 0 <= tempMinute && tempMinute < 30 {
                return "2330"
            }
        }
        
        var result = hour
        
        guard let minute = Int(minute) else { return "" }
        
        if Int(minute) > 30 {
            result += "00"
        } else {
            if Int(hour)! <= 10 {
                result = "0" + String(Int(hour)! - 1)
            } else {
                result = String(Int(hour)! - 1)
            }
            result += "30"
        }
        
        if result == "0000" || result == "0030" {
            return "2330"
        }
        
        return result
    }
    
    func parseCSVAt(url: URL) -> [CityInformation] {
        var cityList: [CityInformation] = []
        
        do {
            // url을 받은 data
            let data = try Data(contentsOf: url)
            // 해당 data를 encoding 합니다.
            let dataEncoded = String(data: data, encoding: .utf8)
            if let dataArr = dataEncoded?.components(separatedBy: "\r\n").map({$0.components(separatedBy: ",")}) {
                                for index in 0..<dataArr.count-1 {
                                    let item = dataArr[index]
                                    let city = CityInformation(code: item[0], province: item[1], city: item[2])
                                    cityList.append(city)
                                }
                            }
        } catch {
            print("Error reading CSV file")
        }
        
        return cityList
    }
    
    func loadCityListFromCSV() -> [CityInformation] {
        // bundle에 있는 경로 > Calorie라는 이름을 가진 csv 파일 경로
        let path = Bundle.main.path(forResource: "CityInformation", ofType: "csv")!
        return parseCSVAt(url: URL(fileURLWithPath: path))
    }
}
