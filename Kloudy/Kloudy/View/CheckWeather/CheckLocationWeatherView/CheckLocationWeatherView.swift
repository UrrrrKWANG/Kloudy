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
    let locationImage: UIImageView = {
        let aLocationIcon = UIImageView()
        //        aLocationIcon.image = UIImage(named: "camera.macro")
        aLocationIcon.image = UIImage(systemName: "location.circle.fill")
        aLocationIcon.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        return aLocationIcon
    }()
    let locationLabel = UILabel()
    let weatherImage: UIImageView = {
        let aweatherImage = UIImageView()
        aweatherImage.image = UIImage(systemName: "cloud.fill")
        aweatherImage.snp.makeConstraints {
            $0.width.equalTo(153)
            $0.height.equalTo(120)
        }
        return aweatherImage
    }()
    let temperatureLabel = UILabel()
    let minmaxStackView = UIStackView()
    let maxStackView = UIStackView()
    let maxTemperatureLabel = UILabel()
    let maxTemperatureImage: UIImageView = {
        let aMaxTemperatureImage = UIImageView()
        aMaxTemperatureImage.image = UIImage(systemName: "arrow.up")
        return aMaxTemperatureImage
    }()
    let minStackView = UIStackView()
    let minTemperatureLabel = UILabel()
    let minTemperatureImage: UIImageView = {
        let aMinTemperatureImage = UIImageView()
        aMinTemperatureImage.image = UIImage(systemName: "arrow.down")
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
    }
    
    func setUp() {
        [nameStackView, weatherImage, temperatureLabel, minmaxStackView, maxStackView, minStackView].forEach {self.addSubview($0)}

        configureLocationLabel()
        configureTemperatureLabel()
        //TODO: 현재 날씨 이미지 위치가 안잡혀서 임시로 넣었습니다.
        weatherImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(50)
            $0.leading.equalToSuperview().inset(17)
        }
        
        [maxStackView, minStackView].forEach {
            minmaxStackView.addArrangedSubview($0)
        }
        minmaxStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(83)
            $0.leading.equalTo(temperatureLabel.snp.trailing).offset(2)
            $0.trailing.equalToSuperview().inset(21)
            $0.bottom.equalToSuperview().inset(26)
        }
        
        maxStackView.clipsToBounds = true
        maxStackView.layer.cornerRadius = 20
        minStackView.clipsToBounds = true
        minStackView.layer.cornerRadius = 20
        
        [nameStackView, maxStackView, minStackView].forEach {configureTemperatureLocationStackView(to: $0)}
        configureminmaxStackView(to: minmaxStackView)
        
        [locationImage, locationLabel].forEach {
            nameStackView.addArrangedSubview($0)
        }
        [maxTemperatureLabel, maxTemperatureImage].forEach {
            maxStackView.addArrangedSubview($0)
        }
        [minTemperatureLabel, minTemperatureImage].forEach {
            minStackView.addArrangedSubview($0)
        }
        
        nameStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
            $0.width.equalTo((locationLabel.text!.count+2) * 15)
        }
        [maxStackView, minStackView].forEach {setStackView(to: $0)}
        
        configureMaxTemperatureLabel()
        configureMinTemperatureLabel()
    }
    
    private func setStackView(to stackView: UIStackView) {
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 20
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 10)
    }
    
    private func configureTemperatureLocationStackView(to stackView: UIStackView) {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
    }
    private func configureminmaxStackView(to stackView: UIStackView) {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 8
    }
    
//TODO: 임시로 위치, 온도 넣었습니다.
    private func configureLocationLabel() {
        locationLabel.text = "서울"
        locationLabel.font = UIFont.KFont.appleSDNeoSemiBoldLarge
        locationLabel.textColor = UIColor.white
        locationLabel.textAlignment = .right
    }
    
    private func configureTemperatureLabel() {
        temperatureLabel.text = "19°"
        temperatureLabel.font = UIFont.KFont.lexendExtraLarge
        temperatureLabel.textColor = UIColor.white
        temperatureLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameStackView.snp.bottom).offset(20)
            $0.width.equalTo(159)
            $0.height.equalTo(125)
        }
    }
    
    private func configureMaxTemperatureLabel() {
        maxTemperatureLabel.text = "최고  19°"
        maxTemperatureLabel.font = UIFont.KFont.appleSDNeoMediumSmall
        maxTemperatureLabel.textColor = UIColor.white
        maxTemperatureImage.snp.makeConstraints {
            $0.size.equalTo(20)
        }
    }
    private func configureMinTemperatureLabel() {
        minTemperatureLabel.text = "최저  12°"
        minTemperatureLabel.font = UIFont.KFont.appleSDNeoMediumSmall
        minTemperatureLabel.textColor = UIColor.white
        minTemperatureImage.snp.makeConstraints {
            $0.size.equalTo(20)
        }
    }
}
