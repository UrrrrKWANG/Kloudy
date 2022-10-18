//
//  CheckWeatherBasicNavigationView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import SnapKit

class CheckWeatherBasicNavigationView: UIView {
    let buttonStackView = UIStackView()
    let bellButton = UIButton()
    let locationButton = UIButton()
    let settingButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(buttonStackView)
        
        [bellButton, locationButton, settingButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        configureButtonStackView()
        
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(52)
        }
        
        configureBellButton()
        configureLocationButton()
        configureSettingButton()
    }
    
    private func configureButtonStackView() {
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .center
        buttonStackView.distribution = .fillProportionally
        buttonStackView.spacing = 24
    }
    
    private func configureBellButton() {
        //TODO: Asset/Resource 파일 생성 시 수정
        bellButton.setImage(UIImage(systemName: "bell"), for: .normal)
        self.bellButton.snp.makeConstraints {
            $0.width.equalTo(18)
            $0.height.equalTo(19)
        }
    }
    
    private func configureLocationButton() {
        locationButton.setImage(UIImage(systemName: "location"), for: .normal)
        self.locationButton.snp.makeConstraints {
            $0.size.equalTo(19)
        }
    }
    
    private func configureSettingButton() {
        settingButton.setImage(UIImage(systemName: "seal"), for: .normal)
        self.settingButton.snp.makeConstraints {
            $0.width.equalTo(18)
            $0.height.equalTo(20)
        }
    }
}
