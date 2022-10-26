//
//  LocationManager.swift
//  Kloudy
//
//  Created by 이주화 on 2022/10/26.
//
//  Reference: https://github.com/PLREQ/PLREQ/blob/develop/PLREQ/PLREQ/Views/MatchView/MatchViewController.swift


import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLatitude : Double = 0.0
    var currentLongitude : Double = 0.0
    var currentLocation: String = ""
    let cities: [String] = ["서울특별시", "대구광역시", "부산광역시", "울산광역시", "광주광역시", "대전광역시", "인천광역시"]
    
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
            let locale = Locale(identifier: "Ko-kr")
            geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale) { [weak self] (place, error) in
                if let address: [CLPlacemark] = place {
                    let locality = "\(address.last?.locality ?? "")"
                    if !self!.cities.contains(locality) { // 지역명이 특별시, 광역시일 경우 더 자세한 지역명을 저장한다.
                        self!.currentLocation = locality
                    } else {
                        let subLocality = "\(address.last?.subLocality ?? "")"
                        self!.currentLocation = "\(locality) \(subLocality)"
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error \(error.localizedDescription)")
    }
}
