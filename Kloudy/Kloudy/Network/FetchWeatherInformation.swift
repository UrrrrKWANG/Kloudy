//
//  FetchWeatherInformation.swift
//  Kloudy
//
//  Created by Geunil Park on 2022/10/18.
//

import Foundation

class FetchWeatherInformation: ObservableObject {
    
    @Published var result: Weather = Weather(today: "", main: [Main(currentWeather: 0, currentTemperature: 0, dayMaxTemperature: 0, dayMinTemperature: 0)], weatherIndex: [WeatherIndex(umbrellaIndex: 0, maskIndex: [MaskIndex(airQuality: 0, flowerQuality: 0, dustQuality: 0)])])
    
    func startLoad(province:String, city: String) {
        // 도시 이름을 받아서 x, y값 받음
        let cityCode = getCityInformaiton(province: province, city: city)
        
        let dayTime = getNowTimeForQuery()
        let day = dayTime[0], time = dayTime[1]
        
        // x, y값을 쿼리로 넣은 url을 만듦 (urlComponents)
        var urlComponents = URLComponents(string: "http://3.35.230.34:8080/apis/weather")
        let codeQuery = URLQueryItem(name: "cityCode", value: cityCode)

        urlComponents?.queryItems = [codeQuery]
        // URLSessionConfiguration을 만듦
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // 데이터 테스크를 만듦
        guard let requestURL = urlComponents?.url else { return }
        
        let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
            
            let successRange = 200..<300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode)
            else {
                print(error?.localizedDescription)
                return
            }
            
            guard let resultData = data else {
                print("data가 없음")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                let response = try decoder.decode(Weather.self, from: resultData)
                self.result = response
                print(response)
                
            } catch let error {
                print("JSON Decoding Error: \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }
    
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
            if let dataArr = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: ",")}) {
                                for item in dataArr {
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
