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
        let xy = findCityCoordinate(city: city)
        let x = xy[0], y = xy[1]
        let dayTime = getNowTimeForQuery()
        let day = dayTime[0], time = dayTime[1]
        
        // x, y값을 쿼리로 넣은 url을 만듦 (urlComponents)
        var urlComponents = URLComponents(string: "http://127.0.0.1:8000/api/weather")
        
        let xQuery = URLQueryItem(name: "x", value: x)
        let yQuery = URLQueryItem(name: "y", value: y)
        let dayQuery = URLQueryItem(name: "day", value: day)
        let timeQuery = URLQueryItem(name: "time", value: time)
        
        urlComponents?.queryItems?.append(xQuery)
        urlComponents?.queryItems?.append(yQuery)
        urlComponents?.queryItems?.append(dayQuery)
        urlComponents?.queryItems?.append(timeQuery)
        
        // URLSessionConfiguration을 만듬
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
        dateFormatter.dateFormat = "yyyyMMdd HHmm"
        let tempString = dateFormatter.string(from: nowDate).split(separator: " ")
        
        let day = String(tempString[0])
        // 시간은 무조건 30분 단위임 -> Int(x/30) * 30 == 30 단위
        let time = String((Int(tempString[1])! / 30) * 30)
        
        return [day, time]
    }
}
