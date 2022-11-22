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
    let dummyData: Weather = Weather(today: "20221122", localWeather: [LocalWeather(localCode: "970304", localName: "데이터 불러오는 중", main: [Main(currentWeather: 0, currentTemperature: 10.8, dayMaxTemperature: 15.0, dayMinTemperature: 9.0)], weatherIndex: [WeatherIndex(umbrellaIndex: [ UmbrellaIndex(status: 0, precipitation24H: 0.0, precipitation1hMax: 0.0, precipitation3hMax: 0.0, wind: 1.4125000000000003, umbrellaHourly: [ UmbrellaHourly(time: 0, precipitation: 0.0),  UmbrellaHourly(time: 1, precipitation: 0.0),  UmbrellaHourly(time: 2, precipitation: 0.0),  UmbrellaHourly(time: 3, precipitation: 0.0),  UmbrellaHourly(time: 4, precipitation: 0.0),  UmbrellaHourly(time: 5, precipitation: 0.0),  UmbrellaHourly(time: 6, precipitation: 0.0),  UmbrellaHourly(time: 7, precipitation: 0.0),  UmbrellaHourly(time: 8, precipitation: 0.0),  UmbrellaHourly(time: 9, precipitation: 0.0),  UmbrellaHourly(time: 10, precipitation: 0.0),  UmbrellaHourly(time: 11, precipitation: 0.0),  UmbrellaHourly(time: 12, precipitation: 0.0),  UmbrellaHourly(time: 13, precipitation: 0.0),  UmbrellaHourly(time: 14, precipitation: 0.0),  UmbrellaHourly(time: 15, precipitation: 0.0),  UmbrellaHourly(time: 16, precipitation: 0.0),  UmbrellaHourly(time: 17, precipitation: 0.0),  UmbrellaHourly(time: 18, precipitation: 0.0),  UmbrellaHourly(time: 19, precipitation: 0.0),  UmbrellaHourly(time: 20, precipitation: 0.0),  UmbrellaHourly(time: 21, precipitation: 0.0),  UmbrellaHourly(time: 22, precipitation: 0.0),  UmbrellaHourly(time: 23, precipitation: 0.0)])], maskIndex: [ MaskIndex(status: 3, pm25value: 45.0, pm10value: 66.0, pollenIndex: 0)], outerIndex: [ OuterIndex(status: 3, dayMinTemperature: 7.0, morningTemperature: 8.5)], laundryIndex: [ LaundryIndex(status: 2, humidity: 23.75, dayMaxTemperature: 16.0, dailyWeather: 0)], carwashIndex: [ CarwashIndex(status: 1, dailyWeather: 4, dayMaxTemperature: 15.0, dailyPrecipitation: 0.08333333333333333, tomorrowWeather: 4, tomorrowPrecipication: 0.0, weather3Am7pm: "6일 후", pm10grade: 66, pollenIndex: 0)], compareIndex: [ CompareIndex(yesterdayMaxTemperature: 16.0, yesterdayMinTemperature: 7.0, todayMaxtemperature: 16.0, todayMinTemperature: 7.0)])], weeklyWeather: [ WeeklyWeather(day: 0, status: 1, maxTemperature: 15.0, minTemperature: 9.0),  WeeklyWeather(day: 1, status: 0, maxTemperature: 14.0, minTemperature: 5.0),  WeeklyWeather(day: 2, status: 3, maxTemperature: 15.0, minTemperature: 6.0),  WeeklyWeather(day: 3, status: 3, maxTemperature: 12.0, minTemperature: 8.0),  WeeklyWeather(day: 4, status: 3, maxTemperature: 13.0, minTemperature: 5.0),  WeeklyWeather(day: 5, status: 4, maxTemperature: 14.0, minTemperature: 8.0),  WeeklyWeather(day: 6, status: 4, maxTemperature: 11.0, minTemperature: 5.0),  WeeklyWeather(day: 7, status: 3, maxTemperature: 5.0, minTemperature: 1.0),  WeeklyWeather(day: 8, status: 0, maxTemperature: 4.0, minTemperature: -2.0),  WeeklyWeather(day: 9, status: 0, maxTemperature: 3.0, minTemperature: -2.0)], hourlyWeather: [ HourlyWeather(hour: 0, status: 3, temperature: 10.0, precipitation: 0.0),  HourlyWeather(hour: 1, status: 4, temperature: 13.0, precipitation: 0.0),  HourlyWeather(hour: 2, status: 4, temperature: 14.0, precipitation: 0.0),  HourlyWeather(hour: 3, status: 4, temperature: 15.0, precipitation: 0.0),  HourlyWeather(hour: 4, status: 4, temperature: 16.0, precipitation: 0.0),  HourlyWeather(hour: 5, status: 4, temperature: 16.0, precipitation: 0.0),  HourlyWeather(hour: 6, status: 4, temperature: 16.0, precipitation: 0.0),  HourlyWeather(hour: 7, status: 4, temperature: 16.0, precipitation: 0.0),  HourlyWeather(hour: 8, status: 4, temperature: 14.0, precipitation: 0.0),  HourlyWeather(hour: 9, status: 4, temperature: 13.0, precipitation: 0.0),  HourlyWeather(hour: 10, status: 4, temperature: 13.0, precipitation: 0.0),  HourlyWeather(hour: 11, status: 4, temperature: 12.0, precipitation: 0.0),  HourlyWeather(hour: 12, status: 4, temperature: 12.0, precipitation: 0.0),  HourlyWeather(hour: 13, status: 3, temperature: 11.0, precipitation: 0.0),  HourlyWeather(hour: 14, status: 0, temperature: 11.0, precipitation: 0.0),  HourlyWeather(hour: 15, status: 3, temperature: 10.0, precipitation: 0.0),  HourlyWeather(hour: 16, status: 3, temperature: 10.0, precipitation: 0.0),  HourlyWeather(hour: 17, status: 3, temperature: 9.0, precipitation: 0.0),  HourlyWeather(hour: 18, status: 3, temperature: 9.0, precipitation: 0.0),  HourlyWeather(hour: 19, status: 3, temperature: 8.0, precipitation: 0.0),  HourlyWeather(hour: 20, status: 3, temperature: 8.0, precipitation: 0.0),  HourlyWeather(hour: 21, status: 3, temperature: 8.0, precipitation: 0.0),  HourlyWeather(hour: 22, status: 3, temperature: 8.0, precipitation: 0.0),  HourlyWeather(hour: 23, status: 3, temperature: 8.0, precipitation: 0.0)])])
    
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
