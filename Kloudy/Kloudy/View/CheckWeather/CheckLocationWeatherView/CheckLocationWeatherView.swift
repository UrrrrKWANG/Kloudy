//
//  CheckLocationWeatherView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import SnapKit

class CheckLocationWeatherView: UIView {
    
    let nameStackView = UIStackView()
    
    let locationImage: UIImageView = {
        let aLocationIcon = UIImageView()
        //        aLocationIcon.image = UIImage(named: "camera.macro")
        aLocationIcon.image = UIImage(systemName: "camera.macro")
        aLocationIcon.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        return aLocationIcon
    }()
    let locationLabel = UILabel()
    let weatherImage: UIImageView = {
        let aweatherImage = UIImageView()
        aweatherImage.image = UIImage(systemName: "camera.macro")
        aweatherImage.snp.makeConstraints {
            $0.size.equalTo(20)
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
        aMaxTemperatureImage.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        return aMaxTemperatureImage
    }()
    
    let minStackView = UIStackView()
    let minTemperatureLabel = UILabel()
    let minTemperatureImage: UIImageView = {
        let aMinTemperatureImage = UIImageView()
        aMinTemperatureImage.image = UIImage(systemName: "arrow.down")
        aMinTemperatureImage.snp.makeConstraints {
            $0.size.equalTo(20)
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
        
    }
    
    func setUp() {
        // 서브뷰 소환
        self.addSubview(nameStackView)
        self.addSubview(temperatureLabel)
        self.addSubview(minmaxStackView)
        self.addSubview(maxStackView)
        self.addSubview(minStackView)

        configureLocationLabel()
        configuretemperatureLabel()
        
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
        
        maxStackView.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.width.equalTo(92)
        }
        minStackView.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.width.equalTo(92)
        }
        
        // 스택뷰 초기 설정
        configureStackView()
        // 스택뷰이기 때문에 차례대로 소환
        [locationImage, locationLabel].forEach {
            nameStackView.addArrangedSubview($0)
        }
        [maxTemperatureLabel, maxTemperatureImage].forEach {
            maxStackView.addArrangedSubview($0)
        }
        [minTemperatureLabel, minTemperatureImage].forEach {
            minStackView.addArrangedSubview($0)
        }
        
        // 스택뷰 콘스트레인트 설정
        nameStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
//            $0.height.equalTo(32)
//            $0.width.equalTo(100)
            $0.width.equalTo((locationLabel.text!.count+2) * 15)
                        
        }
        
        // 스택뷰 안에 콘스트레인트 설정
        
        configureMaxTemperatureLabel()
        configureMinTemperatureLabel()
    }
    private func configureStackView() {
        nameStackView.axis = .horizontal
        nameStackView.alignment = .center
        nameStackView.distribution = .fillProportionally
        nameStackView.spacing = 0
        
        minmaxStackView.axis = .vertical
        minmaxStackView.alignment = .center
        minmaxStackView.distribution = .fillEqually
        minmaxStackView.spacing = 8

        maxStackView.axis = .horizontal
        maxStackView.alignment = .center
        maxStackView.distribution = .fillProportionally
        maxStackView.spacing = 0
        
        minStackView.axis = .horizontal
        minStackView.alignment = .center
        minStackView.distribution = .fillProportionally
        minStackView.spacing = 0
    }
    
    
    private func configureMinTemperatureImage() {
        minTemperatureImage.snp.makeConstraints {
//            $0.centerY.equalTo(minStackView)
            $0.trailing.equalTo(minStackView.snp.trailing).offset(25)
            $0.size.equalTo(20)
        }
    }
    
    private func configureLocationLabel() {
        locationLabel.text = "서울"
        locationLabel.font = locationLabel.font.withSize(18)
        locationLabel.textAlignment = .right
        //        locationLabel.backgroundColor = .black
//        locationLabel.snp.makeConstraints {
//            $0.centerX.equalTo(nameStackView)
//            $0.trailing.equalTo(nameStackView.snp.trailing).offset(0)
//        }
    }
    
    private func configuretemperatureLabel() {
        temperatureLabel.text = "19°"
        temperatureLabel.font = temperatureLabel.font.withSize(100)
//        temperatureLabel.backgroundColor = .black
        temperatureLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameStackView.snp.bottom).offset(20)
            $0.width.equalTo(159)
            $0.height.equalTo(125)
        }
    }
    
    private func configureMaxTemperatureLabel() {
        maxTemperatureLabel.text = "최고  19°"
        maxTemperatureLabel.font = maxTemperatureLabel.font.withSize(12)
        maxTemperatureLabel.snp.makeConstraints {
            $0.centerY.equalTo(maxStackView)
            $0.leading.equalTo(maxStackView.snp.leading).inset(12)
//            $0.width.equalTo(50)
            $0.trailing.equalTo(maxTemperatureImage.snp.leading).offset(0)
        }
        maxTemperatureImage.snp.makeConstraints {
            $0.centerY.equalTo(maxStackView)
            $0.trailing.equalTo(maxStackView.snp.trailing).offset(12)
//            $0.width.equalTo(50)
//            $0.trailing.equalTo(maxTemperatureImage.snp.leading).offset(0)
        }
    }
    private func configureMinTemperatureLabel() {
        minTemperatureLabel.text = "최저  12°"
        minTemperatureLabel.font = maxTemperatureLabel.font.withSize(12)
        minTemperatureLabel.snp.makeConstraints {
            $0.centerY.equalTo(minStackView)
            $0.leading.equalTo(minStackView.snp.leading).offset(12)
        }
    }
}

