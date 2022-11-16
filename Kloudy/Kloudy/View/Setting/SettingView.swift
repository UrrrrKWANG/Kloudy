//
//  SettingView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/07.
//

import UIKit
import SnapKit

class SettingView: UIViewController {
    
    let labelView = UILabel()
    override func viewDidLoad() {
        view.backgroundColor = UIColor.KColor.white
        view.addSubview(labelView)
        labelView.configureLabel(text: "세팅뷰입니다.", font: UIFont.KFont.lexendLarge, textColor: UIColor.KColor.primaryBlue01)
        labelView.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.center.equalToSuperview()
        }
    }
}

