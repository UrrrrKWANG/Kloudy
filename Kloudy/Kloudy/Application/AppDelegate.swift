//
//  AppDelegate.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/13.
//

import UIKit
import CoreData
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    var locationCount = CoreDataManager.shared.countLocations()
    var defaultData = Weather(today: "20221122", localWeather: [Kloudy.LocalWeather(localCode: "1111000000", localName: "데이터 불러오는 중", main: [Kloudy.Main(currentWeather: 0, currentTemperature: 10.8, dayMaxTemperature: 15.0, dayMinTemperature: 9.0)], weatherIndex: [Kloudy.WeatherIndex(umbrellaIndex: [Kloudy.UmbrellaIndex(status: 0, precipitation24H: 0.0, precipitation1hMax: 0.0, precipitation3hMax: 0.0, wind: 1.4125000000000003, umbrellaHourly: [Kloudy.UmbrellaHourly(time: 0, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 1, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 2, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 3, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 4, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 5, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 6, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 7, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 8, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 9, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 10, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 11, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 12, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 13, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 14, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 15, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 16, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 17, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 18, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 19, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 20, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 21, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 22, precipitation: 0.0), Kloudy.UmbrellaHourly(time: 23, precipitation: 0.0)])], maskIndex: [Kloudy.MaskIndex(status: 3, pm25value: 45.0, pm10value: 66.0, pollenIndex: 0)], outerIndex: [Kloudy.OuterIndex(status: 3, dayMinTemperature: 7.0, morningTemperature: 8.5)], laundryIndex: [Kloudy.LaundryIndex(status: 2, humidity: 23.75, dayMaxTemperature: 16.0, dailyWeather: 0)], carwashIndex: [Kloudy.CarwashIndex(status: 1, dailyWeather: 4, dayMaxTemperature: 15.0, dailyPrecipitation: 0.08333333333333333, tomorrowWeather: 4, tomorrowPrecipication: 0.0, weather3Am7pm: "6일 후", pm10grade: 66, pollenIndex: 0)], compareIndex: [Kloudy.CompareIndex(yesterdayMaxTemperature: 16.0, yesterdayMinTemperature: 7.0, todayMaxtemperature: 16.0, todayMinTemperature: 7.0)])], weeklyWeather: [Kloudy.WeeklyWeather(day: 0, status: 1, maxTemperature: 15.0, minTemperature: 9.0), Kloudy.WeeklyWeather(day: 1, status: 0, maxTemperature: 14.0, minTemperature: 5.0), Kloudy.WeeklyWeather(day: 2, status: 3, maxTemperature: 15.0, minTemperature: 6.0), Kloudy.WeeklyWeather(day: 3, status: 3, maxTemperature: 12.0, minTemperature: 8.0), Kloudy.WeeklyWeather(day: 4, status: 3, maxTemperature: 13.0, minTemperature: 5.0), Kloudy.WeeklyWeather(day: 5, status: 4, maxTemperature: 14.0, minTemperature: 8.0), Kloudy.WeeklyWeather(day: 6, status: 4, maxTemperature: 11.0, minTemperature: 5.0), Kloudy.WeeklyWeather(day: 7, status: 3, maxTemperature: 5.0, minTemperature: 1.0), Kloudy.WeeklyWeather(day: 8, status: 0, maxTemperature: 4.0, minTemperature: -2.0), Kloudy.WeeklyWeather(day: 9, status: 0, maxTemperature: 3.0, minTemperature: -2.0)], hourlyWeather: [Kloudy.HourlyWeather(hour: 0, status: 3, temperature: 10.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 1, status: 4, temperature: 13.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 2, status: 4, temperature: 14.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 3, status: 4, temperature: 15.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 4, status: 4, temperature: 16.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 5, status: 4, temperature: 16.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 6, status: 4, temperature: 16.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 7, status: 4, temperature: 16.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 8, status: 4, temperature: 14.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 9, status: 4, temperature: 13.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 10, status: 4, temperature: 13.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 11, status: 4, temperature: 12.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 12, status: 4, temperature: 12.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 13, status: 3, temperature: 11.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 14, status: 0, temperature: 11.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 15, status: 3, temperature: 10.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 16, status: 3, temperature: 10.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 17, status: 3, temperature: 9.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 18, status: 3, temperature: 9.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 19, status: 3, temperature: 8.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 20, status: 3, temperature: 8.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 21, status: 3, temperature: 8.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 22, status: 3, temperature: 8.0, precipitation: 0.0), Kloudy.HourlyWeather(hour: 23, status: 3, temperature: 8.0, precipitation: 0.0)])])
    lazy var weathers = [Weather](repeating: defaultData , count: locationCount)
//    let weatherArray = findWeatherInfo(cityCode: locationCode.code ?? "")
    
    lazy var coreDataStack: CoreDataStack = .init(modelName: "Kloudy")
    
    static let sharedAppDelegate: AppDelegate = {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unexpected app delegate type, did it change? \(String(describing: UIApplication.shared.delegate))")
        }
        return delegate
    }()
    
    // 어플리케이션의 런치 프로세스가 끝났을 때 -> Fetch 요청을 보냄, 요청이 끝나고 난 후 메인화면으로 넘어감.
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if locationCount == 0 {
            addLocation(completionHandler: { [self] in
                loadLocation()
            })
        } else {
            loadLocation()
        }
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func addLocation(completionHandler: @escaping() -> ()) {
        DispatchQueue.main.async {
            CoreDataManager().saveLocation(code: "1111000000", city: "Jongno-gu", province: "Seoul", sequence: 0, indexArray: ["rain", "mask", "laundry", "car", "outer"])
            completionHandler()
            self.weathers = [self.defaultData]
        }
    }
    func loadLocation() {
        DispatchQueue.main.async {
            lazy var myLocations = CoreDataManager.shared.fetchLocations()
            for locationIndex in myLocations.indices {
                // 지역 값이 뭔가 잘못된 것이 들어왔다면 끝내야함
                guard let province = myLocations[locationIndex].province else { return }
                guard let city = myLocations[locationIndex].city else { return }
                FetchWeatherInformation.shared.startLoad(province:province, city: city) { response in
                    self.weathers[locationIndex] = response
                }
            }
            let currentStatus = CLLocationManager().authorizationStatus
            
            if currentStatus == .authorizedWhenInUse || currentStatus == .authorizedAlways {
                // 현재 지역의 위도 경도로 기상청에서 제공하는 XY값을 계산 -> XY값으로 현재 지역정보 반환 후 요청을 보냄.
                let XY = LocationManager.shared.requestNowLocationInfo()
                let nowLocation = FetchWeatherInformation.shared.getLocationInfoByXY(x: XY[0], y: XY[1])
                guard let nowLocation = nowLocation else { return }
                FetchWeatherInformation.shared.startLoad(province: nowLocation.province, city: nowLocation.city) { response in
                    self.weathers.append(response)
                }
            }
        }
    }
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentCloudKitContainer(name: "Kloudy")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func loadNowLocationWeather(currentProvince: String, currentCity: String) {
        print([currentProvince, currentCity])
        let nowLocationInfo = FetchWeatherInformation.shared.getLocationInfo(province: currentProvince, city: currentCity)
        
        // 잘못된 도시 정보를 요청할 수 있음.
        if let nowLocation = nowLocationInfo {
            let province = nowLocation.province
            let city = nowLocation.city
            FetchWeatherInformation.shared.startLoad(province:province, city: city) { response in
                self.weathers.append(response)
            }
        }
    }
}
