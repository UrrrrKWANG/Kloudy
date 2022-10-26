//
//  LocationSelectionNavigationView.swift
//  Kloudy
//
//  Created by Seulki Lee on 2022/10/26.
//

import UIKit
import SnapKit

class LocationSelectionNavigationView: UIView {

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
        self.addSubview(backButton)
        self.addSubview(navigationTitle)
        configureBackButton()
        configureNavigationTitle()
    }
    
    private func configureBackButton() {
        backButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        backButton.tintColor = UIColor.KColor.white
        self.backButton.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(20)
            $0.leading.equalToSuperview()
        }
    }
    
    func configureNavigationTitle() {
        navigationTitle.font = UIFont.boldSystemFont(ofSize: 20)
        navigationTitle.text = "지역"
        navigationTitle.textColor = UIColor.KColor.white
        self.navigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
