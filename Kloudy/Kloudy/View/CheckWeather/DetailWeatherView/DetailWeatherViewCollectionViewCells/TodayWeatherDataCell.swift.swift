//
//  DeatailWeatherViewDayCollectionViewCell.swift
//  Kloudy
//
//  Created by Byeon jinha on 2022/11/09.
//

import SnapKit

class TodayWeatherDataCell: UICollectionViewCell{
    static let identifier = "todayWeatherCell"
    let time: UILabel = {
        let uiLabel = UILabel()
        uiLabel.configureLabel(text: "", font: UIFont.KFont.appleSDNeoMediumMedium, textColor: UIColor.KColor.black)
        uiLabel.textAlignment = .center
        return uiLabel
    }()
    
    let weatherCondition: UIImageView = {
        let uiImage = UIImageView()
        uiImage.contentMode = .scaleAspectFit
        return uiImage
    }()
    
    let temperature: UILabel = {
        let uiLabel = UILabel()
        uiLabel.configureLabel(text: "", font: UIFont.KFont.appleSDNeoMediumMedium, textColor: UIColor.KColor.black)
        return uiLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureCell()
        self.setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        [time, weatherCondition, temperature].forEach {
            contentView.addSubview($0)
        }
    }

    func setUpLayout() {
        time.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(18)
        }
        
        weatherCondition.snp.makeConstraints {
            $0.top.equalTo(time.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(38)
        }
    
        temperature.snp.makeConstraints {
            $0.top.equalTo(weatherCondition.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
