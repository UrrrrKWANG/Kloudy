//
//  LocationSelectionNavigationView.swift
//  Kloudy
//
//  Created by Seulki Lee on 2022/10/26.
//

import UIKit
import SnapKit

class LocationSelectionNavigationView: UIView {

    let backButton = UIButton(type: .custom)
    let navigationTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(backButton)
        self.addSubview(navigationTitle)
        configureBackButton()
        configureNavigationTitle()
    }
    
    private func configureBackButton() {
        backButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        backButton.tintColor = UIColor.KColor.gray01
        backButton.setPreferredSymbolConfiguration(.init(pointSize: 24, weight: .regular, scale: .default), forImageIn: .normal)
        self.backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.width.equalTo(36)
            $0.height.equalTo(31)
            $0.leading.equalToSuperview().offset(-10)
        }
    }
    
    func configureNavigationTitle() {
        navigationTitle.font = UIFont.boldSystemFont(ofSize: 20)
        navigationTitle.text = "지역"
        navigationTitle.textColor = UIColor.KColor.gray01
        self.navigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
