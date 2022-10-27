//
//  CheckLocationWeatherView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import SnapKit

class CheckLocationWeatherView: UIView {
//TODO: 임시로 이미지 파일 넣었습니다.
    let nameStackView = UIStackView()
    let viewModel = CheckLocationWeatherViewModel()
    let locationImage: UIImageView = {
        let aLocationIcon = UIImageView()
        aLocationIcon.image = UIImage(named: "location_mark")
        aLocationIcon.snp.makeConstraints {
            $0.width.equalTo(13)
            $0.height.equalTo(16)
        }
        return aLocationIcon
    }()
    let locationLabel = UILabel()
    let weatherImage: UIImageView = {
        let aweatherImage = UIImageView()
        aweatherImage.image = UIImage(named: "cloudySun")
        aweatherImage.snp.makeConstraints {
            $0.width.equalTo(150)
            $0.height.equalTo(157)
        }
        return aweatherImage
    }()
    let temperatureLabel = UILabel()
    let minmaxStackView = UIStackView()
    let maxStackView = UIStackView()
    let maxTemperatureLabel = UILabel()
    let maxTemperatureImage: UIImageView = {
        let aMaxTemperatureImage = UIImageView()
        aMaxTemperatureImage.image = UIImage(named: "arrow_up")
        aMaxTemperatureImage.snp.makeConstraints {
            $0.width.equalTo(8)
            $0.height.equalTo(10)
        }
        return aMaxTemperatureImage
    }()
    let minStackView = UIStackView()
    let minTemperatureLabel = UILabel()
    let minTemperatureImage: UIImageView = {
        let aMinTemperatureImage = UIImageView()
        aMinTemperatureImage.image = UIImage(named: "arrow_down")
        aMinTemperatureImage.snp.makeConstraints {
            $0.width.equalTo(8)
            $0.height.equalTo(10)
        }
        return aMinTemperatureImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUp()
        // api받는 부분
        let text = viewModel.getWeather()
        locationLabel.configureLabel(text: text[0], font: UIFont.KFont.appleSDNeoSemiBoldLarge, textColor: UIColor.KColor.white)
        temperatureLabel.configureLabel(text: text[1], font: UIFont.KFont.lexendExtraLarge, textColor: UIColor.KColor.white)
        temperatureLabel.text = temperatureLabel.text! + "°"
        maxTemperatureLabel.configureLabel(text: text[2], font: UIFont.KFont.appleSDNeoMediumSmall, textColor: UIColor.KColor.gray07)
        maxTemperatureLabel.text = "최고  " + maxTemperatureLabel.text! + "°"
        minTemperatureLabel.configureLabel(text: text[3], font: UIFont.KFont.appleSDNeoMediumSmall, textColor: UIColor.KColor.gray07)
        minTemperatureLabel.text = "최저  " + minTemperatureLabel.text! + "°"
        weatherImage.image = UIImage(named: text[4])
        
        configureNameStackView()
    }
    
    func setUp() {
        [weatherImage, nameStackView, temperatureLabel,minmaxStackView, maxStackView, minStackView ].forEach {
            self.addSubview($0)
        }

        configureTemperatureLabel()
        configureweatherImage()
        
        [maxStackView, minStackView].forEach {
            minmaxStackView.addArrangedSubview($0)
        }
        
        configureminmaxStackView(to: minmaxStackView)
        configureTemperatureStackView(to: maxStackView)
        configureTemperatureStackView(to: minStackView)
        
        [locationImage, locationLabel].forEach {
            nameStackView.addArrangedSubview($0)
        }
        
        [maxTemperatureLabel, maxTemperatureImage].forEach {
            maxStackView.addArrangedSubview($0)
        }
        
        [minTemperatureLabel, minTemperatureImage].forEach {
            minStackView.addArrangedSubview($0)
        }
        
        [maxStackView, minStackView].forEach {
            setStackView(to: $0)
        }
        
        locationLabel.configureLabel(text: "--", font: UIFont.KFont.appleSDNeoSemiBoldLarge, textColor: UIColor.KColor.white)
        locationLabel.textAlignment = .right
        temperatureLabel.configureLabel(text: "--", font: UIFont.KFont.lexendExtraLarge, textColor: UIColor.KColor.white)
        maxTemperatureLabel.configureLabel(text: "최고  --", font: UIFont.KFont.appleSDNeoMediumSmall, textColor: UIColor.KColor.gray07)
        minTemperatureLabel.configureLabel(text: "최저  --", font: UIFont.KFont.appleSDNeoMediumSmall, textColor: UIColor.KColor.gray07)
        
        configureNameStackView()
    }
    
    private func setStackView(to stackView: UIStackView) {
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 20
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
    }
    
    private func configureminmaxStackView(to stackView: UIStackView) {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(83)
            $0.leading.equalTo(temperatureLabel.snp.trailing).offset(2)
            $0.width.equalTo(92)
            $0.height.equalTo(72)
        }
    }
    private func configureTemperatureStackView(to stackView: UIStackView) {
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 20
        stackView.backgroundColor = UIColor.KColor.black
        stackView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
    }
    func configureNameStackView() {
        nameStackView.axis = .horizontal
        nameStackView.alignment = .center
        nameStackView.distribution = .fillProportionally
        nameStackView.spacing = 0
        nameStackView.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
            $0.height.equalTo(30)
            $0.width.equalTo((locationLabel.text!.count) * 14 + 22)
        }
    }
    
    private func configureTemperatureLabel() {
        temperatureLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameStackView.snp.bottom).offset(8)
            $0.width.equalTo(159)
            $0.height.equalTo(125)
        }
    }
    private func configureweatherImage() {
        weatherImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(21)
        }
    }
}
