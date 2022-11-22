//
//  AppDelegate.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/13.
//

import UIKit
import CoreData
import CoreLocation
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    var locationCount = CoreDataManager.shared.countLocations()
    
    let dummyData = FetchWeatherInformation().dummyData
    lazy var weathers = [Weather](repeating: dummyData , count: locationCount+1)
    let disposeBag = DisposeBag()
    lazy var coreDataStack: CoreDataStack = .init(modelName: "Kloudy")
    
    static let sharedAppDelegate: AppDelegate = {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unexpected app delegate type, did it change? \(String(describing: UIApplication.shared.delegate))")
        }
        return delegate
    }()
    
    // 어플리케이션의 런치 프로세스가 끝났을 때 -> Fetch 요청을 보냄, 요청이 끝나고 난 후 메인화면으로 넘어감.
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let currentStatus = CLLocationManager().authorizationStatus
        if locationCount == 0 && (currentStatus == .restricted || currentStatus == .notDetermined || currentStatus == .denied) {
            self.weathers[0] = dummyData
            CityWeatherNetwork().fetchCityWeather(code: "1111000000")
                .subscribe { event in
                    switch event {
                    case .success(let data):
                        self.weathers.append(data)
                    case .failure(let error):
                        print("Error: ", error)
                    }
                }
                .disposed(by: disposeBag)
            CoreDataManager.shared.saveLocation(code: "1111000000", city: "Jongno-gu", province: "Seoul", sequence: CoreDataManager.shared.countLocations(), indexArray: ["rain", "mask", "laundry", "car", "outer"])
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
    
    func loadLocation() {
        lazy var myLocations = CoreDataManager.shared.fetchLocations()
        for locationIndex in myLocations.indices {
            // 지역 값이 뭔가 잘못된 것이 들어왔다면 끝내야함
            guard let province = myLocations[locationIndex].province else { return }
            guard let city = myLocations[locationIndex].city else { return }
            lazy var weathers = [Weather](repeating: dummyData , count: self.locationCount+1)
            FetchWeatherInformation.shared.startLoad(province:province, city: city) { response in
                self.weathers[locationIndex+1] = response
            }
        let currentStatus = CLLocationManager().authorizationStatus
            if currentStatus == .authorizedWhenInUse || currentStatus == .authorizedAlways {
                // 현재 지역의 위도 경도로 기상청에서 제공하는 XY값을 계산 -> XY값으로 현재 지역정보 반환 후 요청을 보냄.
                let XY = LocationManager.shared.requestNowLocationInfo()
                let nowLocation = FetchWeatherInformation.shared.getLocationInfoByXY(x: XY[0], y: XY[1])
                guard let nowLocation = nowLocation else { return }
                FetchWeatherInformation.shared.startLoad(province: nowLocation.province, city: nowLocation.city) { response in
                    self.weathers[0] = response
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
