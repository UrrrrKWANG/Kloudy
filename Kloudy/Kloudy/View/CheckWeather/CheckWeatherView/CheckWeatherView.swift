//
//  CheckWeatherView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import SnapKit

class CheckWeatherView: UIViewController {
    
    let checkWeatherBasicNavigationView = CheckWeatherBasicNavigationView()
    
    override func viewDidLoad() {
        self.view.addSubview(checkWeatherBasicNavigationView)
        
        checkWeatherBasicNavigationView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(47)
            $0.trailing.equalToSuperview().inset(21)
        }
    }
}
