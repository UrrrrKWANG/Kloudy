//
//  WeatherIndexDetailView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/07.
//

import UIKit
import SnapKit
import Charts
import RxSwift
import RxCocoa

enum IndexType {
    case unbrella
    case mask
    case laundry
    case outer
    case car
    case temperatureGap
    
    var titleString: String {
        switch self {
        case .unbrella: return "우산"
        case .mask: return "마스크"
        case .laundry: return "빨래"
        case .outer: return "겉옷"
        case .car: return "세차"
        case .temperatureGap: return "일교차"
        }
    }
}

class WeatherIndexDetailView: UIViewController {
    
    let baseBackgroundView = UIView()
    let baseIndexView = UIView()
    let titleLabel = UILabel()
    let chartView = IndexChartView()
    let presentButtonView = IndexButtonView()
    
    var indexType: IndexType = .unbrella
    
//    var indexType: BehaviorSubject<IndexType> = BehaviorSubject(value: .unbrella)
    
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
            $0.width.equalTo(350)
            $0.height.equalTo(490)
        }
        
        [titleLabel, chartView, presentButtonView].forEach { baseIndexView.addSubview($0) }
        
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
        
        presentButtonView.snp.makeConstraints {
            $0.top.equalTo(chartView.snp.bottom).offset(46)
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(57)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func attribute() {
        self.view.backgroundColor = UIColor.KColor.clear
        configureBaseBackgroundView()
        configurebBaseIndexView()
        configureTitleLabel()
        presentButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPresentButton)))
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
        titleLabel.text = "\(indexType.titleString) 지수"
        titleLabel.textColor = UIColor.KColor.black
        titleLabel.font = UIFont.KFont.appleSDNeoBoldMedium
        titleLabel.sizeToFit()
    }
    
    @objc private func tapBackgroundView() {
        self.dismiss(animated: true)
    }
    
    @objc private func tapPresentButton() {
        
    }
}
