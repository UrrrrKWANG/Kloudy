//
//  CheckWeatherView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import SnapKit

class CheckWeatherView: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        lazy var CheckWeatherPageView = CheckWeatherPageView()
        view.addSubview(CheckWeatherPageView)
        CheckWeatherPageView.snp.makeConstraints {
            $0.height.equalTo(UIScreen.main.bounds.height)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
