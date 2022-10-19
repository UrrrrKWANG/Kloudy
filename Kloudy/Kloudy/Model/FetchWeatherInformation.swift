//
//  FetchWeatherInformation.swift
//  Kloudy
//
//  Created by Geunil Park on 2022/10/18.
//

import Foundation

class FetchWeatherInformation {
    func startLoad(city: String) {
        // 도시 이름을 받아서 x, y값 받음
        let xyCoordinate = findCityCoordinate(city: city)
        let xCoordinate = xyCoordinate[0], yCoordinate = xyCoordinate[1]
        let dayTime = getNowTimeForQuery()
        let day = dayTime[0], time = dayTime[1]
        
        // x, y값을 쿼리로 넣은 url을 만듦 (urlComponents)
        var urlComponents = URLComponents(string: "http://127.0.0.1:8000/api/weather")
        
        let xQuery = URLQueryItem(name: "x", value: xCoordinate)
        let yQuery = URLQueryItem(name: "y", value: yCoordinate)
        let dayQuery = URLQueryItem(name: "day", value: day)
        let timeQuery = URLQueryItem(name: "time", value: time)
        
        urlComponents?.queryItems?.append(xQuery)
        urlComponents?.queryItems?.append(yQuery)
        urlComponents?.queryItems?.append(dayQuery)
        urlComponents?.queryItems?.append(timeQuery)
        
        // URLSessionConfiguration을 만듦
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // 데이터 테스크를 만듦
        guard let requestURL = urlComponents?.url else { return }
        let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
            
            let successRange = 200..<300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) else {
                return
            }
            
            guard let resultData = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Weather.self, from: resultData)
                
                print(response)
                
            } catch let error {
                print("JSON Decoding Error: \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }
    
    func findCityCoordinate(city: String) -> [String] {
        // 나중에 엑셀파일에서 긁어오겠음
        let koreaCitySamples: [CityInformation] = [
            CityInformation(name: "서울시", x: 60, y: 127),
            CityInformation(name: "인천시", x: 55, y: 124),
            CityInformation(name: "수원시", x: 60, y: 121)
        ]
        
        let nowCity = koreaCitySamples.filter{ $0.name == city }[0]
        
        return [String(nowCity.x), String(nowCity.y)]
    }
    
    func getNowTimeForQuery() -> [String] {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd HH mm"
        let tempString = dateFormatter.string(from: nowDate).split(separator: " ")
        
        let day = String(tempString[0])
        let time = calculateTime(timeStrings: tempString.map{ String($0) })
        
        return [day, time]
    }
    
    func calculateTime(timeStrings: [String]) -> String {
        let hour = timeStrings[1]
        let minute = timeStrings[2]
        
        var result = hour
        
        guard let minute = Int(minute) else { return "" }
        
        if Int(minute) < 30 {
            result += "00"
        } else {
            result += "30"
        }
        
        return result
    }
}
