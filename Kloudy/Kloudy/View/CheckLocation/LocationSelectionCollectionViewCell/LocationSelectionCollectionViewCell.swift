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
    
    var isBeingEdited: Bool = false {
            didSet {
                if isBeingEdited {
                    weatherImage.isHidden = true
                    minusButton.isHidden = false
                } else {
                    weatherImage.isHidden = false
                    minusButton.isHidden = true
                }
            }
        }
    
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
    
    private lazy var minusButton: UIImageView = {
            let minusInCircle = UIImageView()
            minusInCircle.image = UIImage(systemName: "minus.circle.fill")
            minusInCircle.tintColor = UIColor.KColor.red
                    minusInCircle.snp.makeConstraints {
                        $0.size.equalTo(26)
                    }
            return minusInCircle
        }()
        
        private lazy var editLine: UIImageView = {
            let lineView = UIImageView()
            lineView.image = UIImage(systemName: "line.3.horizontal")
            lineView.contentMode = .scaleAspectFit
            lineView.tintColor = UIColor.KColor.gray05
            lineView.snp.makeConstraints {
                $0.size.equalTo(26)
            }
            
            return lineView
        }()
    
//    private lazy var normalStackView: UIStackView = {
//            let stackView = UIStackView()
//            stackView.axis = .horizontal
//            stackView.distribution = .fillProportionally
//            stackView.alignment = .fill
//            stackView.spacing = 5
//            stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//            stackView.addArrangedSubview(self.locationNameLabel)
//            stackView.addArrangedSubview(self.weatherImage)
//            stackView.addArrangedSubview(self.diurnalTemperatureLabel)
//            stackView.addArrangedSubview(self.temperatureLabel)
//
//            stackView.backgroundColor = UIColor.KColor.gray02
//            stackView.layer.cornerRadius = 15
//
//            stackView.sizeToFit()
//            stackView.layoutIfNeeded()
//
//            return stackView
//        }()
//
//        private lazy var editStackView: UIStackView = {
//            let stackView = UIStackView()
//            stackView.axis = .horizontal
//            stackView.distribution = .fillProportionally
//            stackView.alignment = .fill
//            stackView.spacing = 5
//            stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//            stackView.addArrangedSubview(self.locationNameLabel)
//            stackView.addArrangedSubview(self.temperatureLabel)
//            stackView.addArrangedSubview(self.editLine)
//
//            stackView.backgroundColor = UIColor.KColor.gray02
//            stackView.layer.cornerRadius = 15
//
//            stackView.sizeToFit()
//            stackView.layoutIfNeeded()
//
//            return stackView
//        }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setLayOut()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: NSCoder) fail")
    }
    
    private func addView() {
        addSubview(weatherImage)
        addSubview(minusButton)
        
        
        [locationNameLabel, weatherImage, temperatureLabel, diurnalTemperatureLabel].forEach() {
            contentView.addSubview($0)
        }
    }
    
    private func setLayOut() {
        
        minusButton.isHidden = true

        minusButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
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
