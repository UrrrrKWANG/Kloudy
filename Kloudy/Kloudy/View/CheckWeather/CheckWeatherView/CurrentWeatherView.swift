//
//  CurrentWeatherView.swift
//  Kloudy
//
//  Created by Hyeongjung on 2022/11/19.
//

import UIKit
import SnapKit

class CurrentWeatherView: UIView {
    var localWeather:[LocalWeather] = []
    
    init(localWeather: [LocalWeather]) {
        super.init(frame: .zero)
        self.localWeather = localWeather
        let main = [Main](localWeather[0].main)
        let hourlyWeather = [HourlyWeather](localWeather[0].hourlyWeather)
//        main[0].dayMaxTemperature
//        main[0].dayMinTemperature
        self.backgroundColor = UIColor.KColor.primaryBlue01
        self.layer.cornerRadius = 15
        
        let locationLabel: UILabel = {
            let locationLabel = UILabel()
            locationLabel.configureLabel(text: localWeather[0].localName, font: UIFont.KFont.appleSDNeoBold16, textColor: UIColor.KColor.white)
            return locationLabel
        }()
        let temperatureLabel: UILabel = {
            let temperatureLabel = UILabel()
            temperatureLabel.configureLabel(text: "\(Int(hourlyWeather[2].temperature))°", font: UIFont.KFont.lexendRegular50, textColor: UIColor.KColor.white)
            return temperatureLabel
        }()
        let locationIcon: UIImageView = {
            let locationIcon = UIImageView()
            locationIcon.contentMode = .scaleAspectFit
            locationIcon.image = UIImage(named: "location_mark")
            return locationIcon
        }()
        
        [locationLabel, locationIcon, temperatureLabel].forEach { self.addSubview($0) }
        
        locationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(20)
        }
        locationIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.trailing.equalTo(locationLabel.snp.leading).offset(-5)
            $0.width.equalTo(11)
            $0.height.equalTo(14)
        }
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(2)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(63)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
