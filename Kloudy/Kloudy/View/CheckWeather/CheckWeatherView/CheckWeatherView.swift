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
    let checkWeatherEditNavigationView = CheckWeatherEditNavigationView()
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
        
        self.view.addSubview(checkWeatherBasicNavigationView)
        self.view.addSubview(checkWeatherEditNavigationView)
    
        self.configureCheckWeatherBasicNavigationView()
        self.configureCheckWeatherEditNavigationView()
        
        // 코드 구현을 위해 BasicNavigationView 의 경우 isHidden 처리
        self.checkWeatherBasicNavigationView.isHidden = true
        
        lazy var CheckWeatherPageView = CheckWeatherPageView()
        view.addSubview(CheckWeatherPageView)
        CheckWeatherPageView.snp.makeConstraints {
            $0.height.equalTo(UIScreen.main.bounds.height)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    private func configureCheckWeatherBasicNavigationView() {
        checkWeatherBasicNavigationView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(47)
            $0.trailing.equalToSuperview().inset(21)
        }
    }
    
    private func configureCheckWeatherEditNavigationView() {
        checkWeatherEditNavigationView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(47)
            $0.leading.equalToSuperview().inset(21)
            $0.trailing.equalToSuperview().inset(21)
            $0.height.equalTo(52)
        }
        checkWeatherEditNavigationView.addCellButton.addTarget(self, action: #selector(presentSelectWeatherCellView), for: .touchUpInside)
    }
    
    @objc func presentSelectWeatherCellView() {
        let selectWeatherCellView = SelectWeatherCellView()
        selectWeatherCellView.modalPresentationStyle = .formSheet
        self.present(selectWeatherCellView, animated: true)
    }
}
