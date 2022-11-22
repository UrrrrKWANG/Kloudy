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
        self.backgroundColor = UIColor.KColor.white
        //TODO: 노티 작업 이후 사용하면 됩니다
//        [settingButton, locationButton, bellButton].forEach {
//            self.addSubview($0)
//        }
        
        [settingButton, locationButton].forEach {
            self.addSubview($0)
        }
        
        configureSettingButton()
        configureLocationButton()
//        configureBellButton()
    }
    
    private func configureBellButton() {
        bellButton.setImage(UIImage(named: "notification"), for: .normal)
        bellButton.snp.makeConstraints {
            $0.size.equalTo(22)
            $0.trailing.equalTo(locationButton.snp.leading).offset(-22)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func configureLocationButton() {
        locationButton.setImage(UIImage(named: "location"), for: .normal)
        locationButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalTo(settingButton.snp.leading).offset(-22)
            $0.centerY.equalToSuperview()
        }
        
    }
    
    private func configureSettingButton() {
        settingButton.setImage(UIImage(named: "setting"), for: .normal)
        self.settingButton.snp.makeConstraints {
            $0.width.equalTo(21.6)
            $0.height.equalTo(24)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
