//
//  LocationManager.swift
//  Kloudy
//
//  Created by 이주화 on 2022/10/26.
//
//  Reference: https://github.com/PLREQ/PLREQ/blob/develop/PLREQ/PLREQ/Views/MatchView/MatchViewController.swift

import CoreLocation
import UIKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    
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
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
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
