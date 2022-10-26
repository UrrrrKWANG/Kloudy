//
//  LocationSelectionViewEditCell.swift
//  Kloudy
//
//  Created by Seulki Lee on 2022/10/27.
//

import UIKit
import SnapKit

class LocationSelectionViewEditCell: UICollectionViewCell {
    static let cellID = "Cell"
    
    let locationName: String = "현재위치"
    let temperature: Int = 20
    
    // 버튼으로 할 경우 이미지 사이즈가 안 키워짐(버튼 사이즈는 키워지는데 안의 이미지는 그대로인듯)
//    private lazy var minusButton: UIButton = {
//        let minusInCircle = UIButton()
//        minusInCircle.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
//        minusInCircle.tintColor = UIColor.KColor.red
//        minusInCircle.snp.makeConstraints {
//            $0.size.equalTo(26)
//        }
//        return minusInCircle
//    }()
    
    // 따라서 우선 이미지뷰로 구현하였습니다.
    private lazy var minusButton: UIImageView = {
       let minusInCircle = UIImageView()
        minusInCircle.image = UIImage(systemName: "minus.circle.fill")
        minusInCircle.tintColor = UIColor.KColor.red
        minusInCircle.snp.makeConstraints {
            $0.size.equalTo(26)
        }
        return minusInCircle
    }()
    
    private lazy var locationNameLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(text: locationName, font: UIFont.KFont.appleSDNeoBoldMedium, textColor: UIColor.KColor.white)
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(text: "\(temperature)°", font: UIFont.KFont.lexendLarge, textColor: UIColor.KColor.white, attributeString: ["°"], attributeColor: [UIColor.KColor.primaryGreen])
        return label
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
    
    // https://gist.github.com/gazolla/19c7771b33fa5f781bc7f5b0aa842dbd
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        stackView.addArrangedSubview(self.locationNameLabel)
        stackView.addArrangedSubview(self.temperatureLabel)
        stackView.addArrangedSubview(self.editLine)
        
        stackView.backgroundColor = UIColor.KColor.gray02
        stackView.layer.cornerRadius = 15
        
        stackView.sizeToFit()
        stackView.layoutIfNeeded()
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setLayOut()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: NSCoder) fail")
    }
    
//    private func addView() {
//        [minusButton, locationNameLabel, temperatureLabel, editLine].forEach() {
//            contentView.addSubview($0)
//        }
//    }
    
    private func addView() {
        [minusButton, stackView].forEach() {
            contentView.addSubview($0)
        }
    }
    
    private func setLayOut() {
        minusButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.leading.equalTo(50)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        locationNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }

        temperatureLabel.snp.makeConstraints {
            $0.trailing.equalTo(-45)
            $0.centerY.equalToSuperview()
        }

        editLine.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
