//
//  FetchWeatherInformation.swift
//  Kloudy
//
//  Created by Geunil Park on 2022/10/18.
//

import Foundation

class FetchWeatherInformation: ObservableObject {
    static let shared: FetchWeatherInformation = FetchWeatherInformation()
//    let koreanCities: [CityInformation] = loadCityListFromCSV()
    let dummyData: Weather = Weather(today: "dummy", localWeather: [LocalWeather(localCode: "dummy", localName: "dummy", main: [Main(currentWeather: 0, currentTemperature: 0, dayMaxTemperature: 0, dayMinTemperature: 0)], weatherIndex: [WeatherIndex(umbrellaIndex: [UmbrellaIndex(status: 0, precipitation24H: 0, precipitation1hMax: 0, precipitation3hMax: 0, wind: 0)], maskIndex: [MaskIndex(status: 0, pm25value: 0, pm10value: 0, pollenIndex: 0)], outerIndex: [OuterIndex(status: 0, dayMinTemperature: 0, morningTemperature: 0)], laundryIndex: [LaundryIndex(status: 0, humidity: 0, dayMaxTemperature: 0, dailyWeather: 0)], carwashIndex: [CarwashIndex(status: 0, dailyWeather: 0, dayMaxTemperature: 0, dailyPrecipitation: 0, tomorrowWeather: 0, tomorrowPrecipication: 0, weather3Am7pm: "", pm10grade: 0, pollenIndex: 0)], compareIndex: [CompareIndex(yesterdayMaxTemperature: 0, yesterdayMinTemperature: 0, todayMaxtemperature: 0, todayMinTemperature: 0)])], weeklyWeather: [], hourlyWeather: [])])

    
    func startLoad(province:String, city: String, _ completion: @escaping (Weather) -> Void) {
        // 도시 이름을 받아서 x, y값 받음
        let cityCode = getCityInformaiton(province: province, city: city)
        
        let dayTime = getNowTimeForQuery()
        let day = dayTime[0], time = dayTime[1]
        
        // x, y값을 쿼리로 넣은 url을 만듦 (urlComponents)
        var urlComponents = URLComponents(string: "http://3.35.230.34:8080/apis/weather")
        let codeQuery = URLQueryItem(name: "code", value: cityCode)

        urlComponents?.queryItems = [codeQuery]
        // URLSessionConfiguration을 만듦
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // 데이터 테스크를 만듦
        guard let requestURL = urlComponents?.url else { return }
        
        let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
            let successRange = 200..<300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) else {
                print("잘못된 응답이 들어옴")
                print(error?.localizedDescription)
                return
            }
            
            guard let resultData = data else {
                print("data가 없음")
                return
            }
            
            do {
                print("데이터 받아오는데 성공함")
                let decoder = JSONDecoder()
                let response = try decoder.decode(Weather.self, from: resultData)
                completion(response)
                
            } catch let error {
                print("제이슨 요청 실패")
                print("JSON Decoding Error: \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }
    
    func getCityInformaiton(province:String, city: String) -> String {
        var result = ""
        let koreanCities: [CityInformation] = loadCityListFromCSV()
        let nowCities = koreanCities.filter{ $0.province == province && $0.city == city }
        if nowCities.count > 0 {
            result = koreanCities.filter{ $0.province == province && $0.city == city }[0].code
        }
        return result
    }
    
    func getLocationInfo(province:String, city: String) -> CityInformation? {
        var result: CityInformation?
        let koreanCities: [CityInformation] = loadCityListFromCSV()
        let nowCities = koreanCities.filter{ $0.province == province && $0.city == city }
        if nowCities.count > 0 {
            result = nowCities[0]
        }
        return result
    }
    
    func getLocationInfoByXY(x: Int, y: Int) -> CityInformation? {
        var result: CityInformation?
        let koreanCities: [CityInformation] = loadCityListFromCSV()
        let nowCities = koreanCities.filter{ $0.xCoordination == String(x) && $0.yCoordination == String(y) }
        if nowCities.count > 0 {
            result = nowCities[0]
        }
        return result
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
        let hour = timeStrings[1]
        let minute = timeStrings[2]
        
        if hour == "00" {
            let tempMinute = Int(minute)!
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
        //TODO: 전날과 온도를 비교하는 지수 추가 이후 주석 사용
//        var defaultIndexArray = ["rain", "mask", "laundry", "car", "outer", "temperatureGap"]
        let defaultIndexArray = ["rain", "mask", "laundry", "car", "outer"]
        do {
            // url을 받은 data
            let data = try Data(contentsOf: url)
            // 해당 data를 encoding 합니다.
            let dataEncoded = String(data: data, encoding: .utf8)
            if let dataArr = dataEncoded?.components(separatedBy: "\r\n").map({$0.components(separatedBy: ",")}) {
                                for index in 0..<dataArr.count-1 {
                                    let item = dataArr[index]
                                    let city = CityInformation(code: item[0], province: item[1], city: item[2], indexArray: defaultIndexArray, xCoordination: item[3], yCoordination: item[4])
                                    cityList.append(city)
                                }
                            }
        } catch {
            print("Error reading CSV file")
        }
        
        return cityList
    }
    
    func loadCityListFromCSV() -> [CityInformation] {
        let path = Bundle.main.path(forResource: "CityInformation", ofType: "csv")!
        return parseCSVAt(url: URL(fileURLWithPath: path))
    }
}
