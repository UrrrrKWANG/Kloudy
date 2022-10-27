//
//  LocationSelectionCollectionViewCell.swift
//  Kloudy
//
//  Created by 이주화 on 2022/10/25.
//

import UIKit
import SnapKit

class LocationSelectionCollectionViewCell: UICollectionViewCell {
    var locationName: String = "-"
    var weatherImageInt: Int = 0
    var temperature: Int = 0
    var diurnalTemperature: [Int] = [0, 0]
    
    static let cellID = "Cell"
    
    lazy var locationNameLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(text: locationName, font: UIFont.KFont.appleSDNeoBoldMedium, textColor: UIColor.KColor.white)
        return label
    }()
    
    lazy var weatherImage: UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.image = UIImage(systemName: "map")?.withTintColor(UIColor.KColor.white, renderingMode: .alwaysOriginal)
        uiImageView.snp.makeConstraints {
            $0.size.equalTo(26)
        }
        // weatherImageInt 에 따른 image 반환을 다르게 구현
        return uiImageView
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(text: "\(temperature)°", font: UIFont.KFont.lexendLarge, textColor: UIColor.KColor.white, attributeString: ["°"], attributeColor: [UIColor.KColor.primaryGreen])
        return label
    }()
    
    lazy var diurnalTemperatureLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(text: "\(diurnalTemperature[0])° | \(diurnalTemperature[1])°", font: UIFont.KFont.lexendMini, textColor: UIColor.KColor.gray05, attributeString: ["|"], attributeColor: [UIColor.KColor.gray03])
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
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        diurnalTemperatureLabel.snp.makeConstraints {
            $0.trailing.equalTo(-88)
            $0.centerY.equalToSuperview()
        }
    }
}
