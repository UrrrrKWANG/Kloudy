//
//  LocationManager.swift
//  Kloudy
//
//  Created by 이주화 on 2022/10/26.
//
//  Reference: https://github.com/PLREQ/PLREQ/blob/develop/PLREQ/PLREQ/Views/MatchView/MatchViewController.swift

import CoreLocation
import UIKit

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    static let shared = LocationManager()
    
    var locationManager = CLLocationManager()
    var currentLatitude : Double = 0.0
    var currentLongitude : Double = 0.0
    var currentCity: String = ""
    var currentProvince: String = ""
    let cities: [String] = ["Seoul", "Daegu", "Busan", "Ulsan", "Gwangju", "Daejeon", "Incheon"]
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let findLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let geocoder = CLGeocoder()
            currentLatitude = location.coordinate.latitude
            currentLongitude = location.coordinate.longitude
            let locale = Locale(identifier: "en-US")
            geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale) { [weak self] (place, error) in
                if let address: [CLPlacemark] = place {
                    let locality = "\(address.last?.locality ?? "")"
                    switch locality {
                    case "Seoul":
                        self!.currentCity = "Jongno-gu"
                        self!.currentProvince = "Seoul"
                    case "Daegu":
                        self!.currentCity = "Suseong-gu"
                        self!.currentProvince = "Daegu"
                    case "Busan":
                        self!.currentCity = "Saha-gu"
                        self!.currentProvince = "Busan"
                    case "Ulsan":
                        self!.currentCity = "Ulju-gun"
                        self!.currentProvince = "Ulsan"
                    case "Gwangju":
                        self!.currentCity = "Gwangsan-gu"
                        self!.currentProvince = "Gwangju"
                    case "Daejeon":
                        self!.currentCity = "Yuseong-gu"
                        self!.currentProvince = "Daejeon"
                    case "Incheon":
                        self!.currentCity = "Bupyeong-gu"
                        self!.currentProvince = "Incheon"
                    default:
                        self!.currentCity = locality
                        self!.currentProvince = "\(address.last?.subThoroughfare ?? "")"
                    }
                }
            }
        }
    }
    // https://hanulyun.medium.com/swift-%EA%B2%BD%EB%8F%84-%EC%9C%84%EB%8F%84-%EC%8B%9C-%EA%B5%B0-%EA%B5%AC-%EA%B5%AC%ED%95%98%EA%B8%B0-b77a42c7c924
    func requestNowLocationInfo() -> [Int] {
        var resultX = 0
        var resultY = 0
        locationManager.startUpdatingLocation()
        if let location = locationManager.location {
            let longitude: CLLocationDegrees = location.coordinate.longitude
            let latitude: CLLocationDegrees = location.coordinate.latitude
            let converter: LocationConverter = LocationConverter()
            let (x, y): (Int, Int)
                = converter.convertGrid(lon: longitude, lat: latitude)
            resultX = x
            resultY = y
        }
        
        return [resultX, resultY]
    }
    
    func requestNowLocationInfoCity(completion: @escaping (([String]?) -> ())) {
        var resultProvince = "province"
        var resultCity = "city"
        var resultAddress: [String] = []
        locationManager.startUpdatingLocation()
        if let location = locationManager.location {
            let longitude: CLLocationDegrees = location.coordinate.longitude
            let latitude: CLLocationDegrees = location.coordinate.latitude
            let findLocation: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
            let geoCoder: CLGeocoder = CLGeocoder()
            let local: Locale = Locale(identifier: "Ko-kr")
            geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { (place, error) in
                if let address: [CLPlacemark] = place {
                    if let lines = address.last?.addressDictionary?["FormattedAddressLines"] as? [String] {
                        let placeString = lines.joined(separator: ", ")
                        resultAddress = placeString.components(separatedBy: " ")
                    }
                    guard let country = address.last?.country else { return }
                    guard let startIndex = resultAddress.firstIndex(of: country) else { return }
                    resultProvince = resultAddress[startIndex + 1]
                    resultCity = resultAddress[startIndex + 2]
                    completion([resultProvince, resultCity])
                    self.locationManager.stopUpdatingLocation()
                }
            }
        }
    }
//    func requestLocationAuthorization() {
//        self.locationManager.delegate = self
//        let currentStatus = CLLocationManager().authorizationStatus
//
//        // Only ask authorization if it was never asked before
//        guard currentStatus == .notDetermined else { return }
//
//        // Starting on iOS 13.4.0, to get .authorizedAlways permission, you need to
//        // first ask for WhenInUse permission, then ask for Always permission to
//        // get to a second system alert
//        if #available(iOS 13.4, *) {
//            self.requestLocationAuthorizationCallback = { status in
//                if status == .authorizedWhenInUse {
//                    self.locationManager.requestAlwaysAuthorization()
//                }
//            }
//            self.locationManager.requestWhenInUseAuthorization()
//        } else {
//            self.locationManager.requestAlwaysAuthorization()
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error \(error.localizedDescription)")
    }
}

