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
        label.text = "Location"
        label.font.withSize(12)
        
        return label
    }()
    
    private lazy var weatherImage: UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.image = UIImage(systemName: "map")
        return uiImageView
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "20"
        label.font.withSize(12)
        return label
    }()
    
    private lazy var diurnalTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "20 | 30"
        label.font.withSize(12)
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
            $0.top.bottom.equalTo(36)
        }
        
        weatherImage.snp.makeConstraints {
            $0.leading.equalTo(152)
            $0.top.bottom.equalTo(35)
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.trailing.equalTo(20)
            $0.top.equalTo(40)
        }
        
        diurnalTemperatureLabel.snp.makeConstraints {
            $0.trailing.equalTo(20)
            $0.top.bottom.equalTo(26)
        }
    }
}
