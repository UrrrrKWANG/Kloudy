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
    var delegate: collectionViewCelDeleteButtonlClicked?
    static let cellID = "Cell"
    var indexPath: Int = 0
    
    var isBeingEdited: Bool = false {
        didSet {
            setLayOut()
        }
    }
    
    lazy var cellBackgroundView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.KColor.gray02
        uiView.layer.cornerRadius = 15
        return uiView
    }()
    
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
        label.configureLabel(text: "\(temperature)°", font: UIFont.KFont.lexendLarge, textColor: UIColor.KColor.white, attributeString: ["°"], attributeColor: [UIColor.KColor.primaryBlue01])
        return label
    }()
    
    lazy var editCellBackgroundView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.KColor.gray02
        uiView.layer.cornerRadius = 15
        return uiView
    }()
    
    lazy var editLocationNameLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(text: locationName, font: UIFont.KFont.appleSDNeoBoldMedium, textColor: UIColor.KColor.white)
        return label
    }()
    
    lazy var editTemperatureLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(text: "\(temperature)°", font: UIFont.KFont.lexendLarge, textColor: UIColor.KColor.white, attributeString: ["°"], attributeColor: [UIColor.KColor.primaryBlue01])
        return label
    }()
    
    lazy var diurnalTemperatureLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(text: "\(diurnalTemperature[0])° | \(diurnalTemperature[1])°", font: UIFont.KFont.lexendMini, textColor: UIColor.KColor.gray03, attributeString: ["|"], attributeColor: [UIColor.KColor.gray03])
        return label
    }()
    
    private lazy var minusButton: UIImageView = {
            let minusInCircle = UIImageView()
            minusInCircle.image = UIImage(systemName: "minus.circle.fill")
            minusInCircle.tintColor = UIColor.KColor.primaryBlue02
                    minusInCircle.snp.makeConstraints {
                        $0.size.equalTo(26)
                    }
            return minusInCircle
        }()
        
    private lazy var editLine: UIImageView = {
        let lineView = UIImageView()
        lineView.image = UIImage(systemName: "line.3.horizontal")
        lineView.contentMode = .scaleAspectFit
        lineView.tintColor = UIColor.KColor.primaryBlue02
        lineView.snp.makeConstraints {
            $0.size.equalTo(26)
        }
        
        return lineView
    }()
    
    let clearButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setLayOut()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: NSCoder) fail")
    }
    
    private func addView() {
        
        [cellBackgroundView, editCellBackgroundView, minusButton, locationNameLabel, weatherImage, temperatureLabel, diurnalTemperatureLabel, editLine,  editLocationNameLabel, editTemperatureLabel,clearButton].forEach() {
            contentView.addSubview($0)
        }
    }
    
    private func setLayOut() {
        
        if isBeingEdited {
            [editCellBackgroundView, editLocationNameLabel, editTemperatureLabel, minusButton, editLine, minusButton, editLine, clearButton].forEach() {
                $0.isHidden = false
            }
            [cellBackgroundView, diurnalTemperatureLabel, locationNameLabel, weatherImage, temperatureLabel].forEach() {
                $0.isHidden = true
            }
            
            editCellBackgroundView.snp.makeConstraints {
                $0.top.bottom.trailing.equalToSuperview().inset(0)
                $0.leading.equalToSuperview().inset(50)
            }
            
            minusButton.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(10)
                $0.centerY.equalToSuperview()
            }
            
            editLocationNameLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(70)
//                $0.trailing.equalToSuperview().inset(0)
                $0.centerY.equalToSuperview()
            }
            
            editTemperatureLabel.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(130)
                $0.centerY.equalToSuperview()
            }
            
            editLine.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(20)
                $0.centerY.equalToSuperview()
            }
            
            clearButton.snp.makeConstraints {
                $0.width.equalTo(50)
                $0.leading.top.bottom.equalToSuperview()
            }
            clearButton.backgroundColor = UIColor.KColor.clear
            clearButton.addTarget(self, action: #selector(self.deleteLocationAlert), for: .touchUpInside)

            
        } else {
            [editCellBackgroundView, editLocationNameLabel, editTemperatureLabel, minusButton, editLine, clearButton].forEach() {
                $0.isHidden = true
            }
            [cellBackgroundView, diurnalTemperatureLabel, locationNameLabel, weatherImage, temperatureLabel].forEach() {
                $0.isHidden = false
            }
            cellBackgroundView.snp.makeConstraints {
                $0.top.bottom.leading.trailing.equalToSuperview().inset(0)
            }
            
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
            
            editLine.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(20)
                $0.centerY.equalToSuperview()
            }
        }
        
    }
    @objc private func deleteLocationAlert() {
        delegate?.buttonClicked(indexPath: indexPath)
    }
}
