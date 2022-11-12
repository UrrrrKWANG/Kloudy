//
//  WeatherIndexDetailView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/07.
//

import UIKit
import SnapKit
import Charts

enum IndexType {
    case unbrella
    case mask
    case laundry
    case outer
    case car
    case temperatureGap
}

class WeatherIndexDetailView: UIViewController {
    
    let baseIndexView = UIView()
    let baseBackgroundView = UIView()
    let titleLabel = UILabel()
    let chartView = IndexChartView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        attribute()
        
    }
    
    private func layout() {
        [baseBackgroundView, baseIndexView].forEach { view.addSubview($0) }
        
        baseBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        baseIndexView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(490)
        }
        
        [titleLabel, chartView].forEach { baseIndexView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.leading.equalToSuperview().inset(16)
        }
        
        chartView.snp.makeConstraints {
            // 하루 강수량 view 에 맞게 top constraint 재부여 필요
            $0.top.equalTo(titleLabel).offset(120)
            $0.height.equalTo(190)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func attribute() {
        self.view.backgroundColor = UIColor.KColor.clear
        configureBaseBackgroundView()
        configurebBaseIndexView()
        configureTitleLabel()
    }
    
    private func configureBaseBackgroundView() {
        baseBackgroundView.backgroundColor = UIColor.KColor.clear.withAlphaComponent(0.5)
        baseBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBackgroundView)))
    }
    
    private func configurebBaseIndexView() {
        baseIndexView.backgroundColor = UIColor.KColor.white
        baseIndexView.layer.cornerRadius = 10
    }
    
    private func configureTitleLabel() {
        titleLabel.text = "우산 지수"
        titleLabel.textColor = UIColor.KColor.black
        titleLabel.font = UIFont.KFont.appleSDNeoBoldLarge
        titleLabel.sizeToFit()
    }
    
    @objc private func tapBackgroundView() {
        self.dismiss(animated: true)
    }
}
