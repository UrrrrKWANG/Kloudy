//
//  WeatherIndexStepView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/13.
//

import UIKit
import SnapKit
import RxSwift

class WeatherIndexStepView: UIViewController {
    
    let baseBackgroundView = UIView()
    let baseIndexView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        attribute()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.8, delay: 0) {
            self.baseIndexView.backgroundColor = UIColor.KColor.white
        }
    }
    
    private func layout() {
        [baseBackgroundView, baseIndexView].forEach { self.view.addSubview($0) }
        
        baseBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        baseIndexView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(350)
            $0.height.equalTo(490)
        }
        
    }
    
    private func attribute() {
        self.view.backgroundColor = UIColor.KColor.clear
        configureBaseBackgroundView()
        configurebBaseIndexView()
    }
    
    private func configureBaseBackgroundView() {
        baseBackgroundView.backgroundColor = UIColor.KColor.clear
        baseBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBackgroundView)))
    }
    
    private func configurebBaseIndexView() {
        
        baseIndexView.backgroundColor = UIColor.KColor.clear
        baseIndexView.layer.cornerRadius = 10
    }
    
    @objc private func tapBackgroundView() {
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
}
