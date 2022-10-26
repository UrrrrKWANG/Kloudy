//
//  LocationSelectionCollectionViewCell.swift
//  Kloudy
//
//  Created by 이주화 on 2022/10/25.
//

import UIKit
import SnapKit

class LocationSelectionCollectionViewCell: UICollectionViewCell {
    
    private lazy var locationNameLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(text: "현재위치", font: UIFont.KFont.appleSDNeoBoldMedium, textColor: UIColor.KColor.white)
        return label
    }()
    
    private lazy var weatherImage: UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.image = UIImage(systemName: "map")
        uiImageView.snp.makeConstraints {
            $0.size.equalTo(26)
        }
        return uiImageView
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(text: "20°", font: UIFont.KFont.lexendLarge, textColor: UIColor.KColor.white, attributeString: ["°"], attributeColor: [UIColor.KColor.primaryGreen])
        return label
    }()
    
    private lazy var diurnalTemperatureLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(text: "20° | 30°", font: UIFont.KFont.lexendMini, textColor: UIColor.KColor.gray05, attributeString: ["|"], attributeColor: [UIColor.KColor.gray03])
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setLayOut()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: NSCoder) fail")
    }
    
    private func addView() {
        [locationNameLabel, weatherImage, temperatureLabel, diurnalTemperatureLabel].forEach() {
            contentView.addSubview($0)
        }
    }
    
    private func setLayOut() {
        locationNameLabel.snp.makeConstraints {
            $0.leading.equalTo(20)
            $0.centerY.equalToSuperview()
        }
        
        weatherImage.snp.makeConstraints {
            $0.leading.equalTo(152)
            $0.centerY.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.trailing.equalTo(-20)
            $0.centerY.equalToSuperview()
        }
        
        diurnalTemperatureLabel.snp.makeConstraints {
            $0.trailing.equalTo(-88)
            $0.centerY.equalToSuperview()
        }
    }
}
