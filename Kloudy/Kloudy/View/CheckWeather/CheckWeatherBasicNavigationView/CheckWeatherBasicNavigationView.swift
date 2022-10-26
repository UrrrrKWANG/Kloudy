//
//  CheckWeatherBasicNavigationView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import SnapKit

class CheckWeatherBasicNavigationView: UIView {
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
        self.addSubview(settingButton)
        self.addSubview(locationButton)
        self.addSubview(bellButton)
        configureSettingButton()
        configureLocationButton()
        configureBellButton()
    }
    
    private func configureBellButton() {
        bellButton.setImage(UIImage(named: "notification"), for: .normal)
        bellButton.snp.makeConstraints {
            $0.width.equalTo(18)
            $0.height.equalTo(19)
            $0.trailing.equalTo(locationButton.snp.leading).offset(-24)
        }
    }
    
    private func configureLocationButton() {
        locationButton.setImage(UIImage(named: "location"), for: .normal)
        locationButton.snp.makeConstraints {
            $0.size.equalTo(19)
            $0.trailing.equalTo(settingButton.snp.leading).offset(-24)
        }
        
    }
    
    private func configureSettingButton() {
        settingButton.setImage(UIImage(named: "setting"), for: .normal)
        self.settingButton.snp.makeConstraints {
            $0.width.equalTo(18)
            $0.height.equalTo(20)
            $0.trailing.equalToSuperview()
        }
    }
}
