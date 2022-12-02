//
//  OnboardingView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/12/02.
//

import UIKit
import SnapKit
import CoreLocation

class OnboardingView: UIViewController {
    
    let nextButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        nextButton.setTitle("다음", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
        
    }
    
    @objc private func tapNextButton() {
        CLLocationManager().requestAlwaysAuthorization()
        CLLocationManager().didCha
        self.navigationController?.pushViewController(ViewController(), animated: true)
    }
}
