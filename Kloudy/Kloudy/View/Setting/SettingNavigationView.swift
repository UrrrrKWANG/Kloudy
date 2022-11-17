//
//  SettingNavigationView.swift
//  Kloudy
//
//  Created by Geunil Park on 2022/11/16.
//

import UIKit
import SnapKit

class SettingNavigationView: UIView {
    let backButton = UIButton()
    let navigationTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [backButton, navigationTitle].forEach { self.addSubview($0) }
        configureBackButton()
        configureNavigationTitle()
    }
    
    private func configureBackButton() {
        backButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        backButton.tintColor = UIColor.KColor.gray01
        self.backButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.leading.equalToSuperview()
        }
    }
    
    func configureNavigationTitle() {
        navigationTitle.font = UIFont.boldSystemFont(ofSize: 20)
        navigationTitle.text = "설정"
        navigationTitle.font = UIFont.KFont.appleSDNeoBold20
        navigationTitle.textColor = UIColor.KColor.gray01
        self.navigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}