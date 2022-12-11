//
//  WeekWeatherDataCell.swift
//  Kloudy
//
//  Created by Byeon jinha on 2022/11/08.
//

import SnapKit

class WeekWeatherDataCell: UICollectionViewCell{
    static let identifier = "weekWeatherCell"
    let dayLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.configureLabel(text: "", font: UIFont.KFont.appleSDNeoMedium20, textColor:  UIColor.KColor.black)
        return uiLabel
    }()
    let weatherCondition: UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.contentMode = .scaleAspectFit
        return uiImageView
    }()
    let minTemperature: UILabel = {
        let uiLabel = UILabel()
        uiLabel.configureLabel(text: "", font: UIFont.KFont.lexendRegular20, textColor: UIColor.KColor.primaryBlue04)
        uiLabel.textAlignment = .right
        return uiLabel
    }()
    let maxTemperature: UILabel = {
        let uiLabel = UILabel()
        uiLabel.configureLabel(text: "", font: UIFont.KFont.lexendRegular20, textColor: UIColor.KColor.primaryBlue01)
        uiLabel.textAlignment = .right
        return uiLabel
    }()
    let dividingLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.configureLabel(text: "|", font: UIFont.KFont.lexendRegular20, textColor: UIColor.KColor.primaryBlue04)
        uiLabel.textAlignment = .center
        return uiLabel
    }()
    let dividingLineView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.KColor.primaryBlue06
        return uiView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        self.addLayout()
        self.setUpLayout()
    }
    private func addLayout() {
        self.layer.masksToBounds = true
        [dayLabel,weatherCondition, minTemperature, maxTemperature, dividingLabel, dividingLineView].forEach{
            contentView.addSubview($0)
        }
    }
    
    private func setUpLayout() {
        dayLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(121)
        }

        weatherCondition.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(dayLabel.snp.trailing)
            $0.width.equalTo(37)
            $0.height.equalTo(37)
        }
        maxTemperature.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.height.width.equalTo(40)
        }
        dividingLabel.snp.makeConstraints{
            $0.trailing.equalTo(maxTemperature.snp.leading)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
            $0.width.equalTo(20)
        }
        minTemperature.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(dividingLabel.snp.leading)
            $0.height.width.equalTo(40)
        }
        dividingLineView.snp.makeConstraints{
            $0.top.equalToSuperview().inset(57)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

