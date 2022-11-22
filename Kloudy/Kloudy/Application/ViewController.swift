//
//  ViewController.swift
//  Kloudy
//
//  Created by Geunil Park on 2022/11/22.
//

import Foundation
import UIKit
import CoreLocation

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.KColor.primaryBlue01
        configure()
        myAnimation()
        
        let fetchDataGroup = DispatchGroup()
        fetchDataGroup.enter()
        DispatchQueue.main.async(group: fetchDataGroup) {
            self.fetchWeatherDatas()
            fetchDataGroup.leave()
        }
        fetchDataGroup.notify(queue: DispatchQueue.main) {
            let checkWeatherView = CheckWeatherView()
            self.navigationController?.pushViewController(checkWeatherView, animated: false)
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
    
    func fetchWeatherDatas() {
        
        let cityInformationModel = FetchWeatherInformation()
        lazy var cityData = cityInformationModel.loadCityListFromCSV()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let myLocations = CoreDataManager.shared.fetchLocations()
        for locationIndex in myLocations.indices {
            // 지역 값이 뭔가 잘못된 것이 들어왔다면 끝내야함
            guard let province = myLocations[locationIndex].province else { return }
            guard let city = myLocations[locationIndex].city else { return }
            FetchWeatherInformation.shared.startLoad(province:province, city: city) { response in
                appDelegate?.weathers[locationIndex] = response
            }
        }
        
        let currentStatus = CLLocationManager().authorizationStatus

        if currentStatus == .authorizedWhenInUse || currentStatus == .authorizedAlways {
            // 현재 지역의 위도 경도로 기상청에서 제공하는 XY값을 계산 -> XY값으로 현재 지역정보 반환 후 요청을 보냄.
            let XY = LocationManager.shared.requestNowLocationInfo()
            let nowLocation = FetchWeatherInformation.shared.getLocationInfoByXY(x: XY[0], y: XY[1])
            guard let nowLocation = nowLocation else { return }
            FetchWeatherInformation.shared.startLoad(province: nowLocation.province, city: nowLocation.city) { response in
                appDelegate?.weathers.append(response)
            }
        }
        
    }
}
