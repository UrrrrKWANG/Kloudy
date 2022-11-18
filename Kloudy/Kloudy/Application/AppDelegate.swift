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
    
    var weathers = [Weather]()
    
    lazy var coreDataStack: CoreDataStack = .init(modelName: "Kloudy")
    
    static let sharedAppDelegate: AppDelegate = {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unexpected app delegate type, did it change? \(String(describing: UIApplication.shared.delegate))")
        }
        return delegate
    }()
    
    // 어플리케이션의 런치 프로세스가 끝났을 때 -> Fetch 요청을 보냄, 요청이 끝나고 난 후 메인화면으로 넘어감.
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let myLocations = CoreDataManager.shared.fetchLocations()
        for location in myLocations {
            // 지역 값이 뭔가 잘못된 것이 들어왔다면 끝내야함
            guard let province = location.province else { return true }
            guard let city = location.city else { return true }
            FetchWeatherInformation.shared.startLoad(province:province, city: city) { response in
                self.weathers.append(response)
            }
        }
        
        let locationManger = CLLocationManager()
        let currentStatus = locationManger.authorizationStatus

        if currentStatus == .authorizedWhenInUse || currentStatus == .authorizedAlways {
            print("제대로 들어옴")
            var currentCity = ""
            var currentProvince = ""
            locationManger.startUpdatingLocation()
            if let location = locationManger.location {
                let longitude: CLLocationDegrees = location.coordinate.longitude
                let latitude: CLLocationDegrees = location.coordinate.latitude
                
//                let converter: LocationConverter = LocationConverter()
//                let (x, y): (Int, Int)
//                    = converter.convertGrid(lon: longitude, lat: latitude)
                
                let findLocation: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
                let geoCoder: CLGeocoder = CLGeocoder()
                let local: Locale = Locale(identifier: "en_US")
                geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { (place, error) in
                    if let address: [CLPlacemark] = place {
                        print("주소 받음")
                        let locality = address.last?.locality
                        switch locality {
                        case "Seoul":
                            currentCity = "Jongno-gu"
                            currentProvince = "Seoul"
                            self.loadNowLocationWeather(currentProvince: currentProvince, currentCity: currentCity)
                        case "Daegu":
                            currentCity = "Suseong-gu"
                            currentProvince = "Daegu"
                            self.loadNowLocationWeather(currentProvince: currentProvince, currentCity: currentCity)
                        case "Busan":
                            currentCity = "Saha-gu"
                            currentProvince = "Busan"
                            self.loadNowLocationWeather(currentProvince: currentProvince, currentCity: currentCity)
                        case "Ulsan":
                            currentCity = "Ulju-gun"
                            currentProvince = "Ulsan"
                            self.loadNowLocationWeather(currentProvince: currentProvince, currentCity: currentCity)
                        case "Gwangju":
                            currentCity = "Gwangsan-gu"
                            currentProvince = "Gwangju"
                            self.loadNowLocationWeather(currentProvince: currentProvince, currentCity: currentCity)
                        case "Daejeon":
                            currentCity = "Yuseong-gu"
                            currentProvince = "Daejeon"
                            self.loadNowLocationWeather(currentProvince: currentProvince, currentCity: currentCity)
                        case "Incheon":
                            currentCity = "Bupyeong-gu"
                            currentProvince = "Incheon"
                            self.loadNowLocationWeather(currentProvince: currentProvince, currentCity: currentCity)
                        default:
                            currentCity = locality ?? ""
                            currentProvince = "\(address.last?.subThoroughfare ?? "")"
                            self.loadNowLocationWeather(currentProvince: currentProvince, currentCity: currentCity)
                        }
                    }
                }
            }
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

