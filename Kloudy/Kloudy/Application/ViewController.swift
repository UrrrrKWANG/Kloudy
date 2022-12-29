//
//  ViewController.swift
//  Kloudy
//
//  Created by Geunil Park on 2022/11/22.
//

import Foundation
import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    var circle1: UIView = {
        let circle = UIView()
        let centerX = UIScreen.main.bounds.size.width * 0.5
        let centerY = UIScreen.main.bounds.size.height * 0.5
        circle.frame = CGRect(x: centerX-32, y: centerY+58.4, width: 9.7, height: 9.7)
        
        circle.layer.backgroundColor = UIColor.KColor.white.cgColor
        circle.layer.cornerRadius = circle.frame.height * 0.5
        return circle
    }()
    
    var circle2: UIView = {
        let circle = UIView()
        let centerX = UIScreen.main.bounds.size.width * 0.5
        let centerY = UIScreen.main.bounds.size.height * 0.5
        circle.frame = CGRect(x: centerX-4.3, y: centerY+58.4, width: 9.7, height: 9.7)
        
        circle.layer.backgroundColor = UIColor.KColor.white.cgColor
        circle.layer.cornerRadius = circle.frame.height * 0.5
        return circle
    }()
    
    var circle3: UIView = {
        let circle = UIView()
        let centerX = UIScreen.main.bounds.size.width * 0.5
        let centerY = UIScreen.main.bounds.size.height * 0.5
        circle.frame = CGRect(x: centerX+23, y: centerY+58.4, width: 9.7, height: 9.7)
        
        circle.layer.backgroundColor = UIColor.KColor.white.cgColor
        circle.layer.cornerRadius = circle.frame.height * 0.5
        return circle
    }()
    
    var logoImageView: UIImageView = {
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        logoImageView.image = UIImage(named: "logo")
        return logoImageView
    }()
    
    let disposeBag = DisposeBag()
    let checkWeatherView = CheckWeatherView()
    let locationCount = CoreDataManager.shared.countLocations()
    let currentStatus = CLLocationManager().authorizationStatus
    let fetchedWeathers: BehaviorRelay<[Weather]> = BehaviorRelay(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.KColor.primaryBlue01
        if NetworkReachability.isConnectedToNetwork() {
            configure()
            myAnimation()
            bind()
            fetchWeatherData()
            didNotFetchedLocation()
        } else {
            navigationController?.pushViewController(NetworkUnreachableView(), animated: false)
        }
    }
    
    private func bind() {
        fetchedWeathers.asObservable()
            .subscribe(onNext: {
                if self.locationCount == 0 {
                    if !$0.isEmpty {
                        self.checkWeatherView.initialWeathers = self.fetchedWeathers.value
                        self.navigationController?.setViewControllers([self.checkWeatherView], animated: false)
                    }
                } else {
                    if (self.currentStatus == .restricted || self.currentStatus == .notDetermined || self.currentStatus == .denied) {
                        if $0.count == self.locationCount {
                            self.checkWeatherView.initialWeathers = self.fetchedWeathers.value
                            self.navigationController?.setViewControllers([self.checkWeatherView], animated: false)
                        }
                    } else {
                        if $0.count == self.locationCount + 1 {
                            self.checkWeatherView.initialWeathers = self.fetchedWeathers.value
                            self.navigationController?.setViewControllers([self.checkWeatherView], animated: false)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func didNotFetchedLocation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if Storage.isFirstBuild() && self.fetchedWeathers.value.isEmpty {
                self.fetchIsFirstLocation()
            }
            if self.locationCount == 0 {
                if !self.fetchedWeathers.value.isEmpty {
                    self.checkWeatherView.isNoCurrentLocation = true
                    self.checkWeatherView.initialWeathers = self.fetchedWeathers.value
                    self.navigationController?.setViewControllers([self.checkWeatherView], animated: false)
                }
            } else {
                if self.fetchedWeathers.value.count == self.locationCount {
                    self.checkWeatherView.isNoCurrentLocation = true
                    self.checkWeatherView.initialWeathers = self.fetchedWeathers.value
                    self.navigationController?.setViewControllers([self.checkWeatherView], animated: false)
                }
            }
        }
    }
    
    private func configure() {
        [circle1, circle2, circle3, logoImageView].forEach { self.view.addSubview($0) }
        
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(3)
            $0.top.equalToSuperview().inset(307)
        }
    }
    
    func myAnimation() {
        
        let centerX = UIScreen.main.bounds.size.width * 0.5
        let centerY = UIScreen.main.bounds.size.height * 0.5
        let oldFrameForCircle1 = CGRect(x: centerX-32, y: centerY+58.4, width: 9.7, height: 9.7)
        let newFrameForCircle1 = CGRect(x: centerX-32, y: centerY+48.4, width: 9.7, height: 9.7)
        
        let oldFrameForCircle2 = CGRect(x: centerX-4.3, y: centerY+58.4, width: 9.7, height: 9.7)
        let newFrameForCircle2 = CGRect(x: centerX-4.3, y: centerY+48.4, width: 9.7, height: 9.7)
        
        let oldFrameForCircle3 = CGRect(x: centerX+23, y: centerY+58.4, width: 9.7, height: 9.7)
        let newFrameForCircle3 = CGRect(x: centerX+23, y: centerY+48.4, width: 9.7, height: 9.7)
        
        UIView.animate(withDuration: 0.7, delay:0, options: [.repeat, .autoreverse], animations: {
            self.circle1.frame = newFrameForCircle1
        }, completion: { finished in
            UIView.animate(withDuration: 1, animations: {
                self.circle1.frame = oldFrameForCircle1
            })
        })
        
        UIView.animate(withDuration: 0.7, delay:0.3, options: [.repeat, .autoreverse], animations: {
            self.circle2.frame = newFrameForCircle2
        }, completion: { finished in
            UIView.animate(withDuration: 1, animations: {
                self.circle2.frame = oldFrameForCircle2
            })
        })
        
        UIView.animate(withDuration: 0.7, delay:0.6, options: [.repeat, .autoreverse], animations: {
            self.circle3.frame = newFrameForCircle3
        }, completion: { finished in
            UIView.animate(withDuration: 1, animations: {
                self.circle2.frame = oldFrameForCircle3
            })
        })
    }
    
    func fetchWeatherData() {
        let currentStatus = CLLocationManager().authorizationStatus
        let locations = CoreDataManager.shared.fetchLocations()
        
        if locations.count == 0 {
            if (currentStatus == .restricted || currentStatus == .notDetermined || currentStatus == .denied) {
                fetchIsFirstLocation()
            } else {
                fetchCurrentLocationWeatherData()
            }
        }
        else {
            if (currentStatus == .restricted || currentStatus == .notDetermined || currentStatus == .denied) {
                fetchLocationsWeatherData(locations: locations)
            } else {
                fetchCurrentLocationWeatherData()
                fetchLocationsWeatherData(locations: locations)
            }
        }
    }
    
    private func fetchLocationsWeatherData(locations: [Location]) {
        for index in locations.indices {
            CityWeatherNetwork().fetchCityWeather(code: locations[index].code ?? "")
                .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
                .subscribe { event in
                    switch event {
                    case .success(let data):
                        DispatchQueue.main.async {
                            self.fetchedWeathers.accept(self.fetchedWeathers.value + [data])
                        }
                    case .failure(let error):
                        print("Error: ", error)
                    }
                }
                .disposed(by: disposeBag)
        }
    }
    
    private func fetchCurrentLocationWeatherData() {
        let XY = LocationManager.shared.requestNowLocationInfo()
        let nowLocation = FetchWeatherInformation.shared.getLocationInfoByXY(x: XY[0], y: XY[1])
        guard let nowLocation = nowLocation else { return }
        
        CityWeatherNetwork().fetchCityWeather(code: nowLocation.code)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe { event in
                switch event {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.fetchedWeathers.accept([data] + self.fetchedWeathers.value)
                    }
                case .failure(let error):
                    print("Error: ", error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchIsFirstLocation() {
        Storage.saveCurrentLocationIndexArray(arrayString: Storage.defaultIndexArray)
        CoreDataManager.shared.saveLocation(code: "1111000000", city: "Jongno-gu", province: "Seoul", sequence: CoreDataManager.shared.countLocations(), indexArray: Storage.defaultIndexArray)
        CityWeatherNetwork().fetchCityWeather(code: "1111000000")
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe { event in
                switch event {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.fetchedWeathers.accept(self.fetchedWeathers.value + [data])
                    }
                case .failure(let error):
                    print("Error: ", error)
                }
            }
            .disposed(by: disposeBag)
    }
}
