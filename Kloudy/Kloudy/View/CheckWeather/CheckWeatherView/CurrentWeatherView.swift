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
    var main:[Main] = []
    var hourlyWeather:[HourlyWeather] = []
    
    let locationLabel = UILabel()
    let currentTemperatureLabel = UILabel()
    let maxTemperatureLabel = UILabel()
    let minTemperatureLabel = UILabel()
    let maxTemperatureView = UIView()
    let minTemperatureView = UIView()
    let temperatureStackView: UIStackView = {
        let temperatureStackView = UIStackView()
        temperatureStackView.axis = .vertical
        temperatureStackView.distribution = .fillEqually
        temperatureStackView.spacing = 4
        return temperatureStackView
    }()
    let locationIcon: UIImageView = {
        let locationIcon = UIImageView()
        locationIcon.image = UIImage(named: "location_mark")
        locationIcon.contentMode = .scaleAspectFit
        return locationIcon
    }()
    let maxTemperatureIcon: UIImageView = {
        let maxTemperatureIcon = UIImageView()
        maxTemperatureIcon.image = UIImage(named: "arrow_up")
        maxTemperatureIcon.contentMode = .scaleAspectFit
        return maxTemperatureIcon
    }()
    let minTemperatureIcon: UIImageView = {
        let minTemperatureIcon = UIImageView()
        minTemperatureIcon.image = UIImage(named: "arrow_down")
        minTemperatureIcon.contentMode = .scaleAspectFit
        return minTemperatureIcon
    }()
    
    init(localWeather: [LocalWeather]) {
        super.init(frame: .zero)
        self.localWeather = localWeather
        self.main = [Main](localWeather[0].main)
        self.hourlyWeather = [HourlyWeather](localWeather[0].hourlyWeather)
        addLayout()
        addData()
        setLayout()
    }
    
    private func addLayout() {
        [locationLabel, locationIcon, temperatureStackView, currentTemperatureLabel].forEach { self.addSubview($0) }
        [maxTemperatureView, minTemperatureView].forEach { temperatureStackView.addArrangedSubview($0) }
        [maxTemperatureIcon, maxTemperatureLabel].forEach { maxTemperatureView.addSubview($0) }
        [minTemperatureIcon, minTemperatureLabel].forEach { minTemperatureView.addSubview($0) }
    }
    private func addData() {
        locationLabel.configureLabel(text: localWeather[0].localName, font: UIFont.KFont.appleSDNeoBold16, textColor: UIColor.KColor.white)
        currentTemperatureLabel.configureLabel(text: "\(Int(hourlyWeather[2].temperature))°", font: UIFont.KFont.lexendRegular50, textColor: UIColor.KColor.white)
        maxTemperatureLabel.configureLabel(text: "\(Int(main[0].dayMaxTemperature))°", font: UIFont.KFont.lexendRegular16, textColor: UIColor.KColor.white)
        minTemperatureLabel.configureLabel(text: "\(Int(main[0].dayMinTemperature))°", font: UIFont.KFont.lexendRegular16, textColor: UIColor.KColor.white)
    }
    private func setLayout() {
        self.backgroundColor = UIColor.KColor.primaryBlue01
        self.layer.cornerRadius = 15
        locationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(19)
        }
        locationIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.trailing.equalTo(locationLabel.snp.leading).offset(-7)
            $0.width.equalTo(13)
            $0.height.equalTo(16)
        }
        temperatureStackView.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(48)
            $0.height.equalTo(44)
        }
        currentTemperatureLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(2)
            $0.trailing.equalTo(temperatureStackView.snp.leading).offset(-12)
            $0.height.equalTo(63)
        }
        maxTemperatureIcon.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(16)
        }
        maxTemperatureLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.height.equalToSuperview()
        }
        minTemperatureIcon.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(16)
        }
        minTemperatureLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.height.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
