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
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        attribute()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkIsAlertDismissed), userInfo: nil, repeats: true)
    }
    
    private func layout() {
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(100)
        }
    }
    
    private func attribute() {
        view.backgroundColor = UIColor.KColor.primaryBlue05
        nextButton.setTitle("다음", for: .normal)
        nextButton.setTitleColor(UIColor.KColor.primaryBlue01, for: .normal)
        nextButton.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
    }
    
    @objc private func tapNextButton() {
        CLLocationManager().requestAlwaysAuthorization()
    }
    
    @objc private func checkIsAlertDismissed() {
        switch CLLocationManager().authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse, .restricted, .denied:
            self.navigationController?.pushViewController(ViewController(), animated: true)
            timer?.invalidate()
        case .notDetermined:
            return
        @unknown default:
            fatalError()
        }
    }
}
