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
        let cityInformation = getCityInformaiton(city: city)
        let xCoordinate = cityInformation[0], yCoordinate = cityInformation[1], airConditionMeasuring = cityInformation[2]
        let dayTime = getNowTimeForQuery()
        let day = dayTime[0], time = dayTime[1]
        
        // x, y값을 쿼리로 넣은 url을 만듦 (urlComponents)
        var urlComponents = URLComponents(string: "http://127.0.0.1:8000/api/weather")
        
        let xQuery = URLQueryItem(name: "x", value: xCoordinate)
        let yQuery = URLQueryItem(name: "y", value: yCoordinate)
        let airQuery = URLQueryItem(name: "air", value: airConditionMeasuring)
        let dayQuery = URLQueryItem(name: "day", value: day)
        let timeQuery = URLQueryItem(name: "time", value: time)
        
        urlComponents?.queryItems?.append(xQuery)
        urlComponents?.queryItems?.append(yQuery)
        urlComponents?.queryItems?.append(airQuery)
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
    
    func getCityInformaiton(city: String) -> [String] {
        let koreanCities: [CityInformation] = loadCityListFromCSV()
        
        let nowCity = koreanCities.filter{ $0.city == city }[0]
        
        return [String(nowCity.xCoordination), String(nowCity.yCoordination), nowCity.airCoditionMeasuring]
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
    
    private func parseCSVAt(url: URL) -> [CityInformation] {
        var cityList: [CityInformation] = []
        
        do {
            // url을 받은 data
            let data = try Data(contentsOf: url)
            // 해당 data를 encoding 합니다.
            let dataEncoded = String(data: data, encoding: .utf8)
            if let dataArr = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: ",")}) {
                                for item in dataArr {
                                    let city = CityInformation(code: item[0], province: item[1], city: item[2], airCoditionMeasuring: item[3], xCoordination: Int(item[4]) ?? 0, yCoordination: Int(item[5]) ?? 0, longitude: Double(item[6]) ?? 0, latitude: Double(item[7]) ?? 0)
                                    cityList.append(city)
                                }
                            }
        } catch {
            print("Error reading CSV file")
        }
        
        return cityList
    }
    
    private func loadCityListFromCSV() -> [CityInformation] {
        // bundle에 있는 경로 > Calorie라는 이름을 가진 csv 파일 경로
        let path = Bundle.main.path(forResource: "CityInformation", ofType: "csv")!
        return parseCSVAt(url: URL(fileURLWithPath: path))
    }
}